// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(BASE_URL),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
}
