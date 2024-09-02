import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';

class ApiService {
  final String _baseUrl = BASE_URL;

  Future<http.Response> postRequest(
      Map<String, dynamic> parameters, token) async {
    if (token == null) {
      token = '';
    } else {
      token = token;
    }
    final url = Uri.parse(_baseUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'token': token
      },
      body: jsonEncode(parameters),
    );

    if (response.statusCode == 200) {
      // Request was successful
      return response;
    } else {
      // Handle error
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed to load data');
    }
  }
}
