import 'dart:convert';
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

Future<void> getTransactionDetails(
    String token, String accountId, String transactionId) async {
  // Define the URL with accountId and transactionId
  final url = Uri.https(
      // 'api.s.unit.sh', '/accounts/$accountId/transactions/$transactionId');
      'api.s.unit.sh',
      '/accounts/$accountId/transactions');
  logger.d(url);
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
    final data = json.decode(response.body);
    // print('Transaction Details: $data');
    logger.d(data);
  } else {
    print('Error: ${response.statusCode}');
    print('Error: ${response.body}');
  }
}

Future<void> getAllTransactions(
  String token,
  String accountId,
) async {
  // Define the URL with accountId and transactionId
  final url = Uri.https('api.s.unit.sh', '/transactions', {
    'filter[accountId]': accountId, // Adding the accountId filter
  });

  logger.d(url);
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
    final data = json.decode(response.body);
    // print('Transaction Details: $data');
    logger.d(data);
  } else {
    print('Error: ${response.statusCode}');
    print('Error: ${response.body}');
  }
}
