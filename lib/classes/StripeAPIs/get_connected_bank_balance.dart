import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>?> getConnectedAccountBalance(
  String connectedAccountId,
  String apiKey,
) async {
  final url = Uri.parse('https://api.stripe.com/v1/balance');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Stripe-Account': connectedAccountId,
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    logger.d(data);
    return {
      "available": data['available']
          .map((balance) =>
              {"amount": balance['amount'], "currency": balance['currency']})
          .toList(),
      "pending": data['pending']
          .map((balance) =>
              {"amount": balance['amount'], "currency": balance['currency']})
          .toList()
    };
  } else {
    if (kDebugMode) {
      print('Failed to retrieve balance: ${response.body}');
    }
    return null; // Return null if the request failed
  }
}

Future<void> fetchConnectedBankBalance(String accountId, apiKey) async {
  String stripeApiKey = apiKey;

  try {
    // Step 1: Refresh the account balance
    final refreshResponse = await http.post(
      Uri.parse(
          'https://api.stripe.com/v1/financial_connections/accounts/$accountId/refresh_balance'),
      headers: {
        'Authorization': 'Bearer $stripeApiKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'features[]': 'balance'
      }, // This ensures that the balance is refreshed
    );

    if (refreshResponse.statusCode == 200) {
      if (kDebugMode) {
        print('Balance refresh initiated successfully.');
      }

      // Step 2: Wait for the balance to be updated
      await Future.delayed(
          Duration(seconds: 2)); // Allow Stripe some time to update the balance

      // Step 3: Fetch the updated account details
      final accountResponse = await http.get(
        Uri.parse(
            'https://api.stripe.com/v1/financial_connections/accounts/$accountId'),
        headers: {
          'Authorization': 'Bearer $stripeApiKey',
        },
      );

      if (accountResponse.statusCode == 200) {
        final accountData = json.decode(accountResponse.body);

        // Extract the balance
        final balance = accountData['balance'];
        final double availableBalance = balance['cash']['available'][0]
                ['amount'] /
            100; // Convert cents to dollars
        final String currency = balance['cash']['available'][0]['currency'];

        print('Available Balance: $availableBalance $currency');
      } else {
        print('Error fetching balance: ${accountResponse.body}');
      }
    } else {
      print('Error initiating balance refresh: ${refreshResponse.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
