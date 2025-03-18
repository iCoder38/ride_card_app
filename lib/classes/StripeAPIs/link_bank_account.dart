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
  required String routingNumber,
  required String firstName,
  required String lastName,
  required String dobDate,
  required String dobMonth,
  required String dobYear,
  required String address,
  required String city,
  required String state,
  required String zipcode,
  required String phone,
}) async {
  String apiKey = dotenv.env["STRIPE_SK_KEY"]!;

  try {
    // Step 1: Create a connected account
    String? connectedAccountId = await createConnectedAccount(
      userEmail,
      apiKey,
      ssnNumber,
      ssnNumber4,
      firstName,
      lastName,
      dobDate,
      dobMonth,
      dobYear,
      address,
      city,
      state,
      zipcode,
      phone,
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
    // Improved error handling
    try {
      // Check if the error is JSON and extract the message
      final errorJson = json.decode(e.toString());
      if (errorJson is Map &&
          errorJson.containsKey('error') &&
          errorJson['error'].containsKey('message')) {
        return {'status': 'error', 'message': errorJson['error']['message']};
      } else {
        return {'status': 'error', 'message': 'An unknown error occurred.'};
      }
    } catch (_) {
      // Return a clean string message if parsing fails
      return {'status': 'error', 'message': e.toString()};
    }
  }
}

// Helper function to create a new connected account
Future<String?> createConnectedAccount(
  String email,
  String apiKey,
  String ssnNumber,
  String ssnNumber4,
  String firstName,
  String lastName,
  String dobDate,
  String dobMonth,
  String dobYear,
  String address,
  String city,
  String state,
  String zipcode,
  String phone,
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
      'business_profile[url]': 'https://ridewallets.com/terms.html',
      'individual[first_name]': firstName.toString(),
      'individual[last_name]': lastName.toString(),
      'individual[dob][day]': dobDate.toString(),
      'individual[dob][month]': dobMonth.toString(),
      'individual[dob][year]': dobYear.toString(),
      'individual[email]': loginUserEmail(),
      'individual[phone]': phone.toString(),
      // address
      'individual[address][line1]': address.toString(),
      'individual[address][city]': city.toString(),
      'individual[address][postal_code]': zipcode.toString(),
      'individual[address][state]': state.toString(),
      // id
      'individual[id_number]': ssnNumber,
      'individual[ssn_last_4]': ssnNumber4,
      'tos_acceptance[date]':
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      'tos_acceptance[ip]': "203.0.113.42",
      // terms
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
    return responseData['id'];
  } else {
    final errorData = json.decode(response.body);
    final errorMessage = errorData['error']['message'];
    throw Exception('Failed to link bank account: $errorMessage');
  }
}

Future<Map<String, String>> updateIdNumber({
  required String accountId,
  required String idNumber,
  required String apiKey,
}) async {
  final url = Uri.parse('https://api.stripe.com/v1/accounts/$accountId');

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'individual[id_number]': idNumber,
      },
    );

    if (response.statusCode == 200) {
      return {
        'status': 'success',
        'message': 'ID number updated successfully.'
      };
    } else {
      final errorResponse = json.decode(response.body);
      return {
        'status': 'error',
        'message':
            errorResponse['error']['message'] ?? 'Unknown error occurred.'
      };
    }
  } catch (e) {
    return {'status': 'error', 'message': e.toString()};
  }
}

// check account status
/*Future<Map<String, dynamic>> checkAccountStatus(
    String accountId, String apiKey) async {
  final url = Uri.parse('https://api.stripe.com/v1/accounts/$accountId');

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Determine if account is fully verified
      final isSuccess = data['requirements']['currently_due'].isEmpty &&
          data['requirements']['past_due'].isEmpty &&
          data['requirements']['disabled_reason'] == null &&
          data['charges_enabled'] == true &&
          data['payouts_enabled'] == true;

      return {
        "success": isSuccess,
        "status": isSuccess
            ? "Account is fully verified and active."
            : "Account has issues.",
        "details": {
          "disabled_reason": data['requirements']['disabled_reason'],
          "currently_due": data['requirements']['currently_due'],
          "past_due": data['requirements']['past_due'],
          "eventually_due": data['requirements']['eventually_due'],
        },
      };
    } else {
      return {
        "success": false,
        "status": "Failed to retrieve account status.",
        "error": json.decode(response.body)['error']['message'],
      };
    }
  } catch (e) {
    return {
      "success": false,
      "status": "An exception occurred.",
      "error": e.toString(),
    };
  }
}*/

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
