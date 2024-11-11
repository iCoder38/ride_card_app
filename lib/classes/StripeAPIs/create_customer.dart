import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String?> createStripeCustomerAPI({
  required String name,
  required String email,
}) async {
  String apiKey = dotenv.env["STRIPE_SK_KEY"].toString();

  final url = Uri.parse('https://api.stripe.com/v1/customers');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'name': name,
      'email': email,
      'description': 'Stripe customer',
    },
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final customerId = responseData['id']; // Retrieve the customer ID
    if (kDebugMode) {
      print('Customer ID: $customerId');
    }
    return customerId;
  } else {
    if (kDebugMode) {
      print('Failed to create customer: ${response.statusCode}');
      print(response.body);
    }
    return null;
  }
}
