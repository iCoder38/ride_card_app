import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';

class GetAllCustomerIssuedCards {
  static Future<List<dynamic>> getParticularCustomerCardViaCustomerId(
      String customerID) async {
    String baseUrl = '$CUSTOMER_CARDS_URL$customerID';
    debugPrint(baseUrl);
    final Uri url = Uri.parse(baseUrl);

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);

        // Access account details from the jsonData map
        var account = jsonData['data'];
        if (account == null || account.isEmpty) {
          if (kDebugMode) {
            print('THERE IS NO CARDS AVAILABLE IN THIS ACCOUNT');
          }
          return [];
        } else {
          if (kDebugMode) {
            debugPrint('===================');
            print('Account details: $account');
            debugPrint('===================');
          }
          return account;
        }
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print('Error fetching account: $jsonData');
        }
        throw Exception('Failed to fetch account details');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      return [];
    }
  }
}
