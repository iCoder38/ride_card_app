import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> createBankAccountTokenAPI({
  required String accountNumber,
  required String country,
  required String currency,
  required String accountHolderName,
  required String accountHolderType,
  String? routingNumber,
}) async {
  String apiKey = dotenv.env["STRIPE_SK_KEY"].toString();

  final url = Uri.parse('https://api.stripe.com/v1/tokens');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      // 'bank_account[bank_name]': 'rajputana 12345',
      'bank_account[account_number]': accountNumber,
      'bank_account[country]': country,
      'bank_account[currency]': currency,
      'bank_account[account_holder_name]': accountHolderName,
      'bank_account[account_holder_type]': accountHolderType,
      if (routingNumber != null) 'bank_account[routing_number]': routingNumber,
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData['id'];
  } else {
    if (kDebugMode) {
      print('Failed to create bank account token: ${response.body}');
    }
    return null;
  }
}

Future<http.Response> attachBankAccountToCustomerAPI({
  required String customerId,
  required String bankAccountToken,
}) async {
  String apiKey = dotenv.env["STRIPE_SK_KEY"].toString();

  final url =
      Uri.parse('https://api.stripe.com/v1/customers/$customerId/sources');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'source': bankAccountToken,
    },
  );

  return response;
}
