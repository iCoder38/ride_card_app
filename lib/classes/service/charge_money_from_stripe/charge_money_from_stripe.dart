import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/service/charge_money_from_stripe/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChargeMoneyStripeService {
  // final String _baseUrl = BASE_URL;

  Future<ChargeResponse?> chargeMoneyFromStripeAfterGettingToken({
    required double amount,
    required String stripeCardToken,
    required String type,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();

    String url = STRIPE_CHARGE_AMOUNT_URL;

    var doubleParse = amount;
    if (type == TAX_TYPE_PERCENTAGE) {
      doubleParse = amount;
    } else {
      doubleParse = doubleParse * 100;
    }

    if (kDebugMode) {
      print(doubleParse);
    }

    // Create the request
    ChargeRequest chargeRequest = ChargeRequest(
      action: 'chargeramount',
      userId: userId.toString(),
      amount: doubleParse,
      tokenID: stripeCardToken.toString(),
    );

    // Encode request as JSON
    String jsonBody = json.encode(chargeRequest.toJson());

    // Define headers
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'token': token,
    };

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonBody,
      );

      if (kDebugMode) {
        print("====> CHARGE REQUEST <====");
        print(response.body);
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return ChargeResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to charge money. Status code: ${response.statusCode}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      return null;
    }
  }
}
