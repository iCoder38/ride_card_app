import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/SquareAPIs/utils/end_points.dart';
import 'package:ride_card_app/classes/SquareAPIs/utils/square_utils.dart';

class SquareService {
  final String baseUrl = squareBaseURL;
  final String accessToken = SQUARE_ACCESS_TOKEN;

  /*Future<http.Response> createCustomer(
      Map<String, dynamic> customerData) async {
    var createCustomerEndPointWithURL =
        '$baseUrl/${Endpoints().endPointCreateCustomer}';
    if (kDebugMode) {
      print(createCustomerEndPointWithURL);
    }
    final response = await http.post(
      Uri.parse(createCustomerEndPointWithURL),
      headers: {
        'Square-Version': '2024-10-17',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(customerData),
    );
    return response;
  }*/
  Future<Map<String, dynamic>> createCustomer(
      Map<String, dynamic> customerData) async {
    var createCustomerEndPointWithURL =
        '$baseUrl/${Endpoints().endPointCreateCustomer}';
    if (kDebugMode) {
      print(createCustomerEndPointWithURL);
    }
    final response = await http.post(
      Uri.parse(createCustomerEndPointWithURL),
      headers: {
        'Square-Version': '2024-10-17',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(customerData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to create customer: ${response.statusCode} ${response.body}');
    }
  }
}
