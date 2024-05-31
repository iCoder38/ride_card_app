import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:uuid/uuid.dart';

//
class CreateAccountService {
  static Future<bool> createAccount(String customerId) async {
    debugPrint('========== ACCOUNT CREATE RESPONSE ================');
    final url = Uri.parse(CREATE_AN_ACCOUNT_URL);
    if (kDebugMode) {
      print(url);
    }

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    // Define the request body
    Map<String, dynamic> requestBody = {
      "data": {
        "type": "depositAccount",
        "attributes": {
          "depositProduct": "checking",
          "tags": {
            "purpose": "spending",
          },
          "idempotencyKey": const Uuid().v4(),
        },
        "relationships": {
          "customer": {
            "data": {
              "type": "customer",
              "id": customerId,
            }
          }
        }
      }
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 201) {
        // If the server returns a 201 Created response
        if (kDebugMode) {
          debugPrint('========== ACCOUNT CREATE RESPONSE ================');
          print(json.decode(response.body));
          debugPrint('===================================================');
        }
        return true;
      } else {
        if (kDebugMode) {
          final jsonData = json.decode(response.body);
          print('Error creating account: $jsonData');
        }
        return false;
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      print('Error: $error');
      return false;
    }
  }
}
