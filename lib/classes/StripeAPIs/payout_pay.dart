import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<void> createPayout({
  required String apiKey,
  required int amount, // Amount in the smallest unit (e.g., cents for USD)
  required String currency,
}) async {
  final url = Uri.parse('https://api.stripe.com/v1/payouts');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'amount': amount.toString(),
      'currency': currency,
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (kDebugMode) {
      print("Payout successful: ${data['id']}");
    }
  } else {
    final error = json.decode(response.body);
    if (kDebugMode) {
      print("Failed to create payout: ${error['error']['message']}");
    }
  }
}

void main() async {
  const apiKey =
      'sk_test_4eC39HqLyjWDarjtT1zdp7dc'; // Replace with your API key
  const double payoutAmount = 10.0; // Example: $10.00
  const String currency = 'usd'; // Change to your desired currency

  // Convert payout amount from double to integer in the smallest unit
  final int amountInSmallestUnit = (payoutAmount * 100).toInt();

  await createPayout(
    apiKey: apiKey,
    amount: amountInSmallestUnit,
    currency: currency,
  );
}
