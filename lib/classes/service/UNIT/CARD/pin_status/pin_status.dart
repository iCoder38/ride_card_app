import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';

class CardPinStatusService {
  static final String _baseUrl = '$SANDBOX_LIVE_URL/cards/';

  Future<Map<String, dynamic>> checkIssuedCardPinStatus(String cardId) async {
    if (kDebugMode) {
      print('=========== CARD PIN STATUS URL =====================');
    }
    //
    String url = '$_baseUrl$cardId/secure-data/pin/status';
    //
    if (kDebugMode) {
      print('=========== CARD PIN STATUS URL =====================');
    }

    debugPrint(url);
    final Uri uri = Uri.parse(url);

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);

        // Access account details from the jsonData map
        var account = jsonData['data'];
        if (account == null || account.isEmpty) {
          if (kDebugMode) {
            print('THERE IS NO CARD AVAILABLE IN THIS ACCOUNT');
          }
          return {};
        } else {
          if (kDebugMode) {
            debugPrint('===================');
            print('Card Pin status: $account');
            debugPrint('===================');
          }
          return account;
        }
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print('Error fetching Card Pin status: $jsonData');
        }
        throw Exception('Failed to fetch Card Pin status');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      return {};
    }
  }
}
