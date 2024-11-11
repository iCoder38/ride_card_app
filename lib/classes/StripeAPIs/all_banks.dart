import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>?> getCustomerBankAccountsAPI(
  String customerId,
) async {
  String apiKey = dotenv.env["STRIPE_SK_KEY"].toString();

  final url = Uri.parse(
      'https://api.stripe.com/v1/customers/$customerId/sources?object=bank_account');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);

    // Check if 'data' contains the list of bank accounts
    final List<dynamic> bankAccounts = responseData['data'] ?? [];

    // Convert list of bank accounts to a list of maps for easier handling
    return bankAccounts
        .map((account) => account as Map<String, dynamic>)
        .toList();
  } else {
    if (kDebugMode) {
      print('Failed to retrieve bank accounts: ${response.body}');
    }
    return null;
  }
}
