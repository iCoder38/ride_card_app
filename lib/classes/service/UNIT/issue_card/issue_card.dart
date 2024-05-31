import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:uuid/uuid.dart';

//
class IssueCardService {
  static Future<bool> issueCard(String bankAccountId) async {
    debugPrint('========== ISSUE CARD RESPONSE ================');
    final url = Uri.parse(ISSUE_CARD_URL);
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
        "type": CARD_INDIVIDUAL_V_D_C_TYPE,
        "attributes": {
          "idempotencyKey": const Uuid().v4(),
          "limits": {
            "dailyWithdrawal": CARD_I_V_D_C_DAILY_WITHDRAWAL,
            "dailyPurchase": CARD_I_V_D_C_DAILY_PURCHASE,
            "monthlyWithdrawal": CARD_I_V_D_C_MONTHLY_WITHDRAWAL,
            "monthlyPurchase": CARD_I_V_D_C_MONTHLY_PURCHASE
          }
        },
        "relationships": {
          "account": {
            "data": {
              "type": "depositAccount",
              "id": bankAccountId,
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
          debugPrint('========== CARD ISSUED RESPONSE ================');
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
