import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> createTransfer({
  required int amount,
  required String currency,
  required String connectedAccountId,
  required String stripeSecretKey,
}) async {
  final url = Uri.parse('https://api.stripe.com/v1/transfers');

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'amount': amount.toString(),
        'currency': currency,
        'destination': connectedAccountId,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Transfer successful: $responseData');
    } else {
      final errorData = jsonDecode(response.body);
      print('Error creating transfer: ${errorData['error']['message']}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> createPayout({
  required int amount,
  required String currency,
  required String connectedAccountId,
  required String stripeSecretKey,
}) async {
  final url = Uri.parse('https://api.stripe.com/v1/payouts');

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Stripe-Account': connectedAccountId, // Set the connected account ID
      },
      body: {
        'amount': amount.toString(),
        'currency': currency,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Payout successful: $responseData');
    } else {
      final errorData = jsonDecode(response.body);
      print('Error creating payout: ${errorData['error']['message']}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
