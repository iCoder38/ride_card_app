import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List<String>> getAccountRequirements(
    String connectedAccountId, String apiKey) async {
  final url =
      Uri.parse('https://api.stripe.com/v1/accounts/$connectedAccountId');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final requirements = data['requirements']['currently_due'];
    return List<String>.from(requirements);
  } else {
    throw Exception("Failed to retrieve account requirements.");
  }
}
