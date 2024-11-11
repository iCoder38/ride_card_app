import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> getStripeBalanceAPI() async {
  String apiKey = dotenv.env["STRIPE_SK_KEY"].toString();

  final url = Uri.parse('https://api.stripe.com/v1/balance');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    if (kDebugMode) {
      print('Failed to retrieve balance: ${response.body}');
    }
    return null;
  }
}
