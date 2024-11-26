import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> getConnectedAccountTransactions(
    String secretKey, String connectedAccountId) async {
  // Pagination-related variables
  List<Map<String, dynamic>> allTransactions = [];
  String? lastTransactionId;

  // Loop to handle pagination and get more transactions
  do {
    // Construct the URL for the API request
    //final url = Uri.parse('https://api.stripe.com/v1/balance_transactions')
    final url = Uri.parse('https://api.stripe.com/v1/payouts')
        .replace(queryParameters: {
      'limit': '100',
      if (lastTransactionId != null) 'starting_after': lastTransactionId,
    });

    // Make the request to Stripe API
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Stripe-Account': connectedAccountId,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      List transactions = responseData['data'];

      // Add the fetched transactions to the list
      allTransactions.addAll(List<Map<String, dynamic>>.from(transactions));

      // Update lastTransactionId for pagination if there are more transactions
      if (responseData['has_more']) {
        lastTransactionId = transactions.last['id'];
      } else {
        lastTransactionId = null; // No more data to fetch
      }
    } else {
      throw Exception(
          'Failed to load connected account transactions: ${response.body}');
    }
  } while (lastTransactionId != null); // Loop until all pages are fetched

  return allTransactions;
}

Future<Map<String, dynamic>> getTransactionDetails(
    String transactionId, String secretKey) async {
  final url = 'https://api.stripe.com/v1/balance_transactions/$transactionId';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $secretKey', // Authentication header
    },
  );

  if (response.statusCode == 200) {
    // If the request is successful, decode the JSON response
    return jsonDecode(response.body);
  } else {
    // If the request fails, throw an exception
    throw Exception('Failed to load transaction details: ${response.body}');
  }
}
