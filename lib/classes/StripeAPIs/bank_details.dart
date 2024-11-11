import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> getBankAccountDetailsAPI(
  String customerId,
  String bankAccountId,
) async {
  String apiKey = dotenv.env["STRIPE_SK_KEY"].toString();

  final url = Uri.parse(
      'https://api.stripe.com/v1/customers/$customerId/sources/$bankAccountId');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData; // Full bank account details
  } else {
    if (kDebugMode) {
      print('Failed to retrieve bank account details: ${response.body}');
    }
    return null;
  }
}
