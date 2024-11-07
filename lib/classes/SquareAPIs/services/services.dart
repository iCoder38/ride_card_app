import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/SquareAPIs/utils/square_utils.dart';

class SquareService {
  final String baseUrl = squareBaseURL;
  // 'https://connect.squareup.com/v2/customers';
  final String accessToken =
      'YOUR_ACCESS_TOKEN'; // Replace with your actual access token

  Future<http.Response> createCustomer(
      Map<String, dynamic> customerData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Square-Version': '2024-10-17',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(customerData),
    );
    return response;
  }
}
