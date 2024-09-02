import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';

class CreateCustomerTokenService {
  static final String _baseUrl = '$SANDBOX_LIVE_URL/customers/';

  Future<String?> getCustomerToken(String customerID) async {
    debugPrint('========== CUSTOMER TOKEN URL ================');
    final url = Uri.parse('$_baseUrl$customerID/token');
    if (kDebugMode) {
      print(url);
    }
    debugPrint('==========================================');

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    // Define the request body
    Map<String, dynamic> requestBody = {
      "data": {
        "type": 'customerToken',
        "attributes": {
          "scope": "customers accounts",
        },
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
          debugPrint('========== CUSTOMER TOKEN ================');
          print(json.decode(response.body));
          debugPrint('===================================================');
        }
        final responseData = json.decode(response.body);
        return responseData['data']['attributes']['token'];
      } else {
        if (kDebugMode) {
          final jsonData = json.decode(response.body);
          print('Error creating customer token: $jsonData');
        }
        return null;
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
      return null;
    }
  }
  //
  // static final String _baseUrl = '$SANDBOX_LIVE_URL/customers/';

  Future<String?> getCustomerTokenVerification(String customerID) async {
    debugPrint('========== CUSTOMER TOKEN VERIFICATION URL ================');
    final url = Uri.parse('$_baseUrl$customerID/token/verification');
    if (kDebugMode) {
      print(url);
    }
    debugPrint('==========================================');

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    // Define the request body
    Map<String, dynamic> requestBody = {
      "data": {
        "type": "customerTokenVerification",
        "attributes": {"channel": "sms"}
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
          debugPrint('========== CUSTOMER TOKEN ================');
          print(json.decode(response.body));
          debugPrint('===================================================');
        }
        final responseData = json.decode(response.body);
        return responseData['data']['attributes']['verificationToken'];
      } else {
        if (kDebugMode) {
          final jsonData = json.decode(response.body);
          print('Error creating customer token: $jsonData');
        }
        return null;
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
      return null;
    }
  }

  //
  Future<String?> createCustomerTokenAfterVerificationCode(
    String type,
    String customerID,
    String verificationToken,
    String verificationCode,
  ) async {
    debugPrint(
        '========== CUSTOMER TOKEN AFTER VERIFICATION CODE ================');
    final url = Uri.parse('$_baseUrl$customerID/token');
    if (kDebugMode) {
      print(url);
    }
    debugPrint('==========================================');

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    var scope = '';
    if (type == '2') {
      scope = "cards-sensitive";
    } else {
      scope = "cards-sensitive-write";
    }
    // Define the request body
    Map<String, dynamic> requestBody = {
      "data": {
        "type": "customerToken",
        "attributes": {
          "scope": scope,
          "verificationToken": verificationToken,
          "verificationCode": verificationCode
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
          debugPrint('========== CUSTOMER TOKEN AFTER ALL ================');
          print(json.decode(response.body));
          debugPrint('===================================================');
        }
        final responseData = json.decode(response.body);
        return responseData['data']['attributes']['token'];
      } else {
        if (kDebugMode) {
          final jsonData = json.decode(response.body);
          print('Error creating customer token: $jsonData');
        }
        return null;
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
      return null;
    }
  }
}
