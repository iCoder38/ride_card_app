import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ride_card_app/classes/common/utils/utils.dart';

Future<void> createBankAccountToken(
    String stripeSecretKey,
    String accountNumber,
    String routingNumber,
    String accountHolderName) async {
  final url = Uri.parse('https://api.stripe.com/v1/tokens');
  final headers = {
    'Authorization':
        'Bearer sk_test_51POkgbCc4YwUErYBQnFMUB9MZseYOA1GVleyN7STW6k4BBL9umjICF4JxnWgl17UfDXbwfmtF5xmI9LFrQPJIrKl00H6WwHpFg', // Your Stripe secret key
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  final body = {
    'bank_account[country]': 'US',
    'bank_account[currency]': 'usd',
    'bank_account[routing_number]': '812345678',
    'bank_account[account_number]': '000123456789',
    'bank_account[account_holder_name]': accountHolderName,
    'bank_account[account_holder_type]': 'individual',
  };

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    String bankToken = responseData['id']; // This is the token you will use
    if (kDebugMode) {
      print('Bank account token created: $bankToken');
    }

    // Now you can use this bankToken to attach it to a Stripe customer or payout
  } else {
    if (kDebugMode) {
      print('Failed to create bank account token: ${response.statusCode}');
      print('Failed to create bank account token: ${response.body}');
    }
  }
}

Future<String?> createStripeCustomer(
  String email,
) async {
  final url = Uri.parse('https://api.stripe.com/v1/customers');
  final headers = {
    'Authorization':
        'Bearer sk_test_51POkgbCc4YwUErYBQnFMUB9MZseYOA1GVleyN7STW6k4BBL9umjICF4JxnWgl17UfDXbwfmtF5xmI9LFrQPJIrKl00H6WwHpFg',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  final body = {
    'email': email,
  };

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData['id']; // This is the Stripe customer ID
  } else {
    if (kDebugMode) {
      print('Failed to create customer: ${response.body}');
    }
    return null;
  }
}

Future<void> attachBankAccountToCustomer(
  String stripeCustomerId,
  String bankToken,
) async {
  final url = Uri.parse(
      'https://api.stripe.com/v1/customers/$stripeCustomerId/sources');
  final headers = {
    'Authorization':
        'Bearer sk_test_51POkgbCc4YwUErYBQnFMUB9MZseYOA1GVleyN7STW6k4BBL9umjICF4JxnWgl17UfDXbwfmtF5xmI9LFrQPJIrKl00H6WwHpFg',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  final body = {
    'source': bankToken,
  };

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print('Bank account attached to customer successfully');
    }
  } else {
    if (kDebugMode) {
      print('Failed to attach bank account: ${response.statusCode}');
    }
  }
}

Future<void> transferFromUnitToStripe(
  String unitApiKey,
  String unitAccountId,
  String stripeBankAccountNumber,
  String stripeRoutingNumber,
  int amountInCents,
) async {
  final url = Uri.parse('https://api.s.unit.sh/payments');
  final headers = {
    'Authorization': 'Bearer $TESTING_TOKEN',
    'Content-Type': 'application/json',
  };

  // final body = jsonEncode({
  //   "data": {
  //     "type": "transfer",
  //     "attributes": {
  //       "amount": amountInCents, // Amount in cents
  //       "sourceAccountId": '4205824',
  //       "destination": {
  //         "type": "external",
  //         "routingNumber": '110000000',
  //         "accountNumber": '000123456789',
  //         "accountType": "checking"
  //       },
  //       "description": "Transfer to Stripe"
  //     }
  //   }
  // });
  final body = jsonEncode({
    "data": {
      "type": "achPayment",
      "attributes": {
        "amount": amountInCents, // Amount in cents
        "direction": "Credit",
        "description": "Wire payment",
        "counterparty": {
          "name": 'purnima pandey',
          "routingNumber": '110000000',
          "accountNumber": '000123456789',
          "address": {
            "street": "9421 Morris Road",
            "city": "Douglasville",
            "state": "GA",
            "postalCode": "30134",
            "country": "US"
          }
        }
      },
      "relationships": {
        "account": {
          "data": {"type": "account", "id": '4205824'}
        }
      }
    }
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    if (kDebugMode) {
      print('Transfer initiated successfully');
    }
  } else {
    if (kDebugMode) {
      print('Failed to initiate transfer: ${response.statusCode}');
      print('Failed to initiate transfer: ${response.body}');
    }
  }
}
