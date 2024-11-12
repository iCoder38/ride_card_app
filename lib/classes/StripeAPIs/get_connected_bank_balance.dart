import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>?> getConnectedAccountBalance(
    String connectedAccountId, String apiKey) async {
  final url = Uri.parse('https://api.stripe.com/v1/balance');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Stripe-Account': connectedAccountId, // Specify the connected account
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {
      "available": data['available']
          .map((balance) =>
              {"amount": balance['amount'], "currency": balance['currency']})
          .toList(),
      "pending": data['pending']
          .map((balance) =>
              {"amount": balance['amount'], "currency": balance['currency']})
          .toList()
    };
  } else {
    print('Failed to retrieve balance: ${response.body}');
    return null; // Return null if the request failed
  }
}
