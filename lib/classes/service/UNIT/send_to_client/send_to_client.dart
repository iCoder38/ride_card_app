import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';

Future<bool> sendPaymentToClientAccount({
  required double amount,
  required String selectedAccountId,
  required BuildContext context,
}) async {
  final url = Uri.parse('https://api.s.unit.sh/payments');
  final headers = {
    'Content-Type': 'application/vnd.api+json',
    'Authorization': 'Bearer $TESTING_TOKEN',
  };

  final body = jsonEncode({
    "data": {
      "type": "bookPayment",
      "attributes": {
        "amount": amount * 100,
        "description": "Convenience fee",
      },
      "relationships": {
        "account": {
          "data": {
            "type": "depositAccount",
            "id": selectedAccountId,
          }
        },
        "counterpartyAccount": {
          "data": {
            "type": "depositAccount",
            "id": dotenv.env['UNIT_BANK_ID'].toString(),
          }
        }
      }
    }
  });

  logger.d(body);

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      String status = jsonData['data']['attributes']['status'];

      if (status == 'Rejected') {
        _handleRejectedPayment(context);
        return false;
      } else {
        logger.d('Payment successful');
        // editWalletBalance(context, amount);
        return true;
      }
    } else {
      logger.e('Failed to send payment: ${response.statusCode}');
      logger.e('Response: ${response.body}');
      return false;
    }
  } catch (error) {
    logger.e('Error occurred: $error');
    return false;
  }
}

void _handleRejectedPayment(BuildContext context) {
  Navigator.pop(context);
  dismissKeyboard(context);
  customToast(
    'Please contact admin.',
    Colors.redAccent,
    ToastGravity.BOTTOM,
  );
}
