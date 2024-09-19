import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';

Future<void> fetchStatements() async {
  final url = Uri.https('api.s.unit.sh', '/statements', {
    'page[limit]': '20',
    'page[offset]': '10',
    // 'filter[accountIds][0]': '1003811039', // '1003811053', // 1003811039
    'filter[accountId]': '4225262',
    'filter[accountType]': 'deposit',
    // 'filter[type][]': 'CheckDeposit', // Added filter for type "book"
    // 'filter[accountIds][1]': '10001',
  });
  logger.d(url);
  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $TESTING_TOKEN',
      },
    );

    if (response.statusCode == 200) {
      // Successful request
      final data = jsonDecode(response.body);
      // print('Response Data: $data');
      Logger().d(data);
    } else {
      // Handle error
      print('Request failed with status: ${response.statusCode}');
      print('Request failed with status: ${response.body}');
    }
  } catch (e) {
    // Handle error
    print('Error occurred: $e');
  }
}

Future<void> fetchCardDetails(String cardId) async {
  // Construct the URL with query parameters
  final url = Uri.https('api.s.unit.sh', '/cards/$cardId', {
    'include': 'customer,account,fees',
    // 'include': 'customer',
  });
  logger.d(url);
  try {
    // Making the GET request
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $TESTING_TOKEN',
      },
    );

    if (response.statusCode == 200) {
      // Successfully fetched data
      final data = jsonDecode(response.body);
      // print('Response Data: $data');
      logger.d(data);
    } else {
      // Handle error
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors
    print('Error occurred: $e');
  }
}

Future<Map<String, dynamic>?> getTransactionDetails(
  String token,
  String accountId,
  String transactionId,
) async {
  final url = Uri.https(
    'api.s.unit.sh',
    '/accounts/$accountId/transactions/$transactionId',
  );

  logger.d(url); // Log the URL for debugging

  // Send the GET request
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  // Check the status code and handle the response
  if (response.statusCode == 200) {
    // Parse the response body
    final Map<String, dynamic> data = json.decode(response.body);
    logger.d(data); // Log the parsed data for debugging

    return data; // Return the parsed data
  } else {
    // Log the error status code and body
    logger.e('Error: ${response.statusCode}');
    logger.e('Error: ${response.body}');

    return null; // Return null if the request fails
  }
}

Future<dynamic> getAllTransactions(
  String token,
  String accountId,
) async {
  // Define the URL with accountId
  final url = Uri.https('api.s.unit.sh', '/transactions', {
    'filter[accountId]': accountId,
  });

  logger.d(url);

  // Send the GET request
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data is Map<String, dynamic>) {
      if (data.containsKey('data')) {
        final transactions = data['data'];
        if (transactions is List) {
          return transactions;
        } else {
          throw Exception(
              'Expected a list of transactions but got something else');
        }
      } else {
        throw Exception('Response does not contain "transactions" key');
      }
    } else {
      throw Exception('Expected a JSON object but got something else');
    }
  } else {
    if (kDebugMode) {
      print('Error: ${response.statusCode}');
      print('Error: ${response.body}');
    }
    throw Exception('Failed to fetch transactions');
  }
}
