import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';

class CheckCardLimitService {
  static Future<dynamic> checkCardLimit(String cardId) async {
    String baseUrl = '$SANDBOX_LIVE_URL/cards/$cardId/limits';

    if (kDebugMode) {
      print(baseUrl);
    }
    final Uri url = Uri.parse(baseUrl);

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
        // body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print(jsonData);
        }
        return jsonData;
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print(jsonData);
        }
        // If the server returns an error response, return the response body
        return jsonData;
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
      return {'error': error.toString()};
    }
  }
}
