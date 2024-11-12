import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
/*import 'package:ride_card_app/classes/common/utils/utils.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';*/

Future<Map<String, String>> connectBankAccount({
  required String userEmail,
  required String accountNumber,
  required String country,
  required String currency,
  required String accountHolderName,
  required String accountHolderType,
  required String ssnNumber,
  required String ssnNumber4,
  String? routingNumber,
}) async {
  String apiKey = dotenv.env["STRIPE_SK_KEY"]!;

  try {
    // Step 1: Create a connected account
    String? connectedAccountId = await createConnectedAccount(
      userEmail,
      apiKey,
      ssnNumber,
      ssnNumber4,
    );
    if (connectedAccountId == null) {
      throw Exception('Failed to create connected account.');
    }

    // Step 2: Create a bank account token
    final bankAccountToken = await createBankAccountToken(
      accountNumber: accountNumber,
      country: country,
      currency: currency,
      accountHolderName: accountHolderName,
      accountHolderType: accountHolderType,
      routingNumber: routingNumber,
      apiKey: apiKey,
    );

    if (bankAccountToken == null) {
      throw Exception('Failed to create bank account token.');
    }

    // Step 3: Link the bank account token to the connected account
    final bankAccountId = await linkBankAccountToConnectedAccount(
      connectedAccountId,
      bankAccountToken,
      apiKey,
    );

    if (bankAccountId == null) throw Exception('Failed to link bank account.');

    // Success: return the bank account ID
    return {'status': 'success', 'message': connectedAccountId};
  } catch (e) {
    // Return the error message if something goes wrong
    return {'status': 'error', 'message': e.toString()};
  }
}

// Helper function to create a new connected account
Future<String?> createConnectedAccount(
  String email,
  String apiKey,
  String ssnNumber,
  String ssnNumber4,
) async {
  final url = Uri.parse('https://api.stripe.com/v1/accounts');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'type': 'custom',
      'country': 'US',
      'email': email,
      'capabilities[card_payments][requested]': 'true',
      'capabilities[transfers][requested]': 'true',
      'capabilities[us_bank_account_ach_payments][requested]': 'true',
      'capabilities[tax_reporting_us_1099_k][requested]': 'true',
      //
      'business_type': 'individual',
      'business_profile[mcc]': '7372',
      'business_profile[url]': 'https://ridewallets.com',
      'individual[first_name]': loginUserName(),
      'individual[last_name]': 'lastName',
      'individual[dob][day]': '06',
      'individual[dob][month]': '06',
      'individual[dob][year]': '1992',
      'individual[email]': loginUserEmail(),
      'individual[phone]': '4025156413',
      // address
      'individual[address][line1]': 'addressLine1',
      'individual[address][city]': 'Maryland',
      'individual[address][postal_code]': '11004',
      'individual[address][state]': 'LA',
      // id
      'individual[id_number]': ssnNumber, // Full ID number if required
      'individual[ssn_last_4]': ssnNumber4, // Last 4 digits of SSN
      'tos_acceptance[date]':
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      'tos_acceptance[ip]': "203.0.113.42",
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData['id'];
  } else {
    throw Exception('Failed to create connected account: ${response.body}');
  }
}

// Function to create a bank account token
Future<String?> createBankAccountToken({
  required String accountNumber,
  required String country,
  required String currency,
  required String accountHolderName,
  required String accountHolderType,
  String? routingNumber,
  required String apiKey,
}) async {
  final url = Uri.parse('https://api.stripe.com/v1/tokens');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'bank_account[account_number]': accountNumber,
      'bank_account[country]': country,
      'bank_account[currency]': currency,
      'bank_account[account_holder_name]': accountHolderName,
      'bank_account[account_holder_type]': accountHolderType,
      if (routingNumber != null) 'bank_account[routing_number]': routingNumber,
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData['id'];
  } else {
    // Extract error details for more specific feedback
    final errorData = json.decode(response.body);
    final errorMessage = errorData['error']['message'];
    throw Exception('Failed to create bank account token: $errorMessage');
  }
}

// Function to link the bank account to the connected account and return the bank account ID
Future<String?> linkBankAccountToConnectedAccount(
  String connectedAccountId,
  String bankAccountToken,
  String apiKey,
) async {
  final url = Uri.parse(
      'https://api.stripe.com/v1/accounts/$connectedAccountId/external_accounts');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'external_account': bankAccountToken,
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData[
        'id']; // Return the bank account ID after successful link
  } else {
    final errorData = json.decode(response.body);
    final errorMessage = errorData['error']['message'];
    throw Exception('Failed to link bank account: $errorMessage');
  }
}

/*Future<void> manageConnectedAccount({
  required String userId, // Unique ID for the user in your system
  required String userEmail,
  required String accountNumber,
  required String country,
  required String currency,
  required String accountHolderName,
  required String accountHolderType,
  int transferAmount = 0, // Default transfer amount (optional)
  String? routingNumber,
}) async {
  String apiKey = dotenv.env["STRIPE_SK_KEY"]!;

  // Step 1: Check if the user already has a connected account ID in your database
  String? connectedAccountId = await getConnectedAccountIdFromDatabase(userId);
  connectedAccountId = userId;

  logger.d('Connected account ==> $connectedAccountId');
  // return;

  // If connectedAccountId exists, we skip creating a new connected account
  if (connectedAccountId != null) {
    if (kDebugMode) {
      print('Using existing connected account: $connectedAccountId');
    }
  } else {
    // Step 2: Create a new connected account if none exists
    connectedAccountId = await createConnectedAccount(userEmail, apiKey);
    if (connectedAccountId == null) {
      print('Failed to create connected account.');
      return;
    }

    // Save the new connectedAccountId to your database
    await saveConnectedAccountIdToDatabase(userId, connectedAccountId);
    print('New connected account created and saved: $connectedAccountId');
  }

  // Step 3: Link the user's bank account if it hasn’t been linked before
  bool isLinked = await linkBankAccountToConnectedAccount(
    connectedAccountId,
    accountNumber,
    country,
    currency,
    accountHolderName,
    accountHolderType,
    routingNumber,
    apiKey,
  );

  if (!isLinked) {
    print('Failed to link bank account.');
    return;
  }

  // Step 4: Transfer funds to the connected account if needed
  /*if (transferAmount > 0) {
    final isTransferred = await transferFundsToConnectedAccount(
      connectedAccountId,
      transferAmount,
      apiKey,
    );

    if (!isTransferred) {
      print('Failed to transfer funds.');
      return;
    }

    // Step 5: Initiate payout to the user’s bank account
    final isPaidOut = await payoutToBankAccount(
      connectedAccountId,
      transferAmount,
      apiKey,
    );

    if (isPaidOut) {
      print('Payout successful!');
    } else {
      print('Failed to payout.');
    }
  }*/
}

// Helper function to create a new connected account
Future<String?> createConnectedAccount(String email, String apiKey) async {
  final url = Uri.parse('https://api.stripe.com/v1/accounts');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'type': 'custom', // Choose 'custom' or 'express'
      'country': 'US', // User's country
      'email': email,
      'capabilities[card_payments][requested]': 'true',
      'capabilities[transfers][requested]': 'true',
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData['id']; // This is the connected account ID
  } else {
    if (kDebugMode) {
      print('Failed to create connected account: ${response.body}');
    }
    return null;
  }
}

// Dummy function to get connected account ID from your database
Future<String?> getConnectedAccountIdFromDatabase(String userId) async {
  // Replace this with your actual database retrieval logic
  if (kDebugMode) {
    print('Retrieving connected account ID for user: $userId');
  }
  return null; // Return null if no account is found
}

// Dummy function to save connected account ID to your database
Future<void> saveConnectedAccountIdToDatabase(
    String userId, String connectedAccountId) async {
  // Replace this with your actual database saving logic
  if (kDebugMode) {
    print('Saving connected account ID for user: $userId');
  }
}

// Function to create and link a bank account to the connected account
Future<bool> linkBankAccountToConnectedAccount(
  String connectedAccountId,
  String accountNumber,
  String country,
  String currency,
  String accountHolderName,
  String accountHolderType,
  String? routingNumber,
  String apiKey,
) async {
  // Step 1: Create a bank account token
  final bankAccountToken = await createBankAccountToken(
    accountNumber: accountNumber,
    country: country,
    currency: currency,
    accountHolderName: accountHolderName,
    accountHolderType: accountHolderType,
    routingNumber: routingNumber,
    apiKey: apiKey,
  );

  if (bankAccountToken == null) {
    if (kDebugMode) {
      print('Failed to create bank account token.');
    }
    return false;
  }

  // Step 2: Link the bank account token to the connected account
  final url = Uri.parse(
      'https://api.stripe.com/v1/accounts/$connectedAccountId/external_accounts');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'external_account': bankAccountToken,
    },
  );

  return response.statusCode == 200;
}

// Helper function to create a bank account token
Future<String?> createBankAccountToken({
  required String accountNumber,
  required String country,
  required String currency,
  required String accountHolderName,
  required String accountHolderType,
  String? routingNumber,
  required String apiKey,
}) async {
  final url = Uri.parse('https://api.stripe.com/v1/tokens');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'bank_account[account_number]': accountNumber,
      'bank_account[country]': country,
      'bank_account[currency]': currency,
      'bank_account[account_holder_name]': accountHolderName,
      'bank_account[account_holder_type]': accountHolderType,
      if (routingNumber != null) 'bank_account[routing_number]': routingNumber,
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData['id'];
  } else {
    print('Failed to create bank account token: ${response.body}');
    return null;
  }
}

// Function to transfer funds to the connected account
Future<bool> transferFundsToConnectedAccount(
    String connectedAccountId, int amount, String apiKey) async {
  final url = Uri.parse('https://api.stripe.com/v1/transfers');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'amount': amount.toString(),
      'currency': 'usd',
      'destination': connectedAccountId,
    },
  );

  return response.statusCode == 200;
}

// Function to initiate a payout to the user's bank account
Future<bool> payoutToBankAccount(
    String connectedAccountId, int amount, String apiKey) async {
  final url = Uri.parse('https://api.stripe.com/v1/payouts');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Stripe-Account': connectedAccountId,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'amount': amount.toString(),
      'currency': 'usd',
    },
  );

  return response.statusCode == 200;
}
*/
