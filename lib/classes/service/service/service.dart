import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = BASE_URL;

  Future<http.Response> postRequest(
      Map<String, dynamic> parameters, token) async {
    if (token == null) {
      token = '';
    } else {
      token = token;
    }
    final url = Uri.parse(_baseUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'token': token
      },
      body: jsonEncode(parameters),
    );

    if (response.statusCode == 200) {
      // Request was successful
      return response;
    } else {
      // Handle error
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> stripePostRequest(
    Map<String, dynamic> parameters,
    token,
  ) async {
    if (token == null) {
      token = '';
    } else {
      token = token;
    }
    final url = Uri.parse(
        'https://demo4.evirtualservices.net/ridewallet/webroot/strip_master/strip_master/customer_test.php');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'token': token
      },
      body: jsonEncode(parameters),
    );

    if (response.statusCode == 200) {
      // Request was successful
      return response;
    } else {
      // Handle error
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> stripeCreateRequest(
    Map<String, dynamic> parameters,
    token,
  ) async {
    if (token == null) {
      token = '';
    } else {
      token = token;
    }
    final url = Uri.parse(
        // 'https://demo4.evirtualservices.net/ridewallet/webroot/strip_master/strip_master/subscribe_test.php');
        'https://app.ridewallets.com/webroot/strip_master/strip_master/subscribe.php');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'token': token
      },
      body: jsonEncode(parameters),
    );

    if (response.statusCode == 200) {
      // Request was successful
      return response;
    } else {
      // Handle error
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed to load data');
    }
  }
}

class RegisterCustomerInStripe {
  final GenerateTokenService _apiServiceGT = GenerateTokenService();
  final ApiService _apiService = ApiService();
  //
  Future<String?> registerCustomerInStripe(String stripeToken) async {
    debugPrint('API ==> REGISTER CUSTOMER IN STRIPE 4');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = prefs.getString('key_save_user_role').toString();

    final parameters = {
      'action': 'customer',
      'userId': userId,
      'name': loginUserName(),
      'email': loginUserEmail(),
      'tokenID': stripeToken.toString(),
    };

    if (kDebugMode) {
      print(parameters);
    }

    try {
      final response = await _apiService.stripePostRequest(parameters, token);
      if (kDebugMode) {
        print(response.body);
      }

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];
      String customerIdIs = jsonResponse['customer_id'];

      if (kDebugMode) {
        print('STATUS ==> $successStatus');
        print(successMessage);
      }

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');

        // Handle token expiration scenario
        if (successMessage == NOT_AUTHORIZED) {
          final newToken = await _apiServiceGT.generateToken(
            userId,
            loginUserEmail(),
            roleIs,
          );

          if (kDebugMode) {
            print('NEW TOKEN ==> $newToken');
          }
          // Re-call the function with the new token
          return await registerCustomerInStripe(stripeToken);
        }

        // Success
        if (successStatus.toLowerCase() == 'success') {
          return customerIdIs; // Return the customer ID
        }
      } else {
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error registering customer in Stripe: $error');
      }
    }

    return null; // Return null if the process fails
  }

  Future<bool> editAfterCreateStripeCustomer(String customerId) async {
    debugPrint('API ==> EDIT PROFILE');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = prefs.getString('key_save_user_role').toString();

    final parameters;
    if (STRIPE_STATUS == 'T') {
      parameters = {
        'action': 'editProfile',
        'userId': userId,
        'stripe_customer_id_Test': customerId,
      };
    } else {
      parameters = {
        'action': 'editProfile',
        'userId': userId,
        'stripe_customer_id_Live': customerId,
      };
    }

    if (kDebugMode) {
      print(parameters);
    }

    try {
      final response = await _apiService.postRequest(parameters, token);
      if (kDebugMode) {
        print(response.body);
      }

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];

      if (kDebugMode) {
        print('STATUS ==> $successStatus');
        print(successMessage);
      }

      if (response.statusCode == 200) {
        debugPrint('EDIT PROFILE: RESPONSE ==> SUCCESS');

        if (successMessage == NOT_AUTHORIZED) {
          final newToken = await _apiServiceGT.generateToken(
            userId,
            loginUserEmail(),
            roleIs,
          );

          if (kDebugMode) {
            print('NEW TOKEN ==> $newToken');
          }

          // Retry the API call with the new token
          return await editAfterCreateStripeCustomer(customerId);
        }

        return successStatus.toLowerCase() ==
            'success'; // Return true if successful
      } else {
        debugPrint('EDIT PROFILE: RESPONSE ==> FAILURE');
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error editing profile: $error');
      }
      return false; // Return false on error
    }
  }

  Future<bool> createSubscription(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = prefs.getString('key_save_user_role').toString();

    final parameters = {
      'action': 'subscription',
      'userId': userId,
      'customerId': customerId,
      'plan_type': 'Account'
    };

    if (kDebugMode) {
      print(parameters);
    }

    try {
      final response = await _apiService.stripeCreateRequest(parameters, token);
      if (kDebugMode) {
        print(response.body);
      }

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];

      if (kDebugMode) {
        print('STATUS ==> $successStatus');
        print(successMessage);
      }

      if (response.statusCode == 200) {
        if (successMessage == NOT_AUTHORIZED) {
          final newToken = await _apiServiceGT.generateToken(
            userId,
            loginUserEmail(),
            roleIs,
          );
          if (kDebugMode) {
            print('NEW TOKEN ==> $newToken');
          }
          return await createSubscription(customerId); // Retry with new token
        }

        if (successStatus.toLowerCase() == 'success') {
          logger.d('SUCCESS: SUBSCRIPTION');
          return true; // Subscription creation was successful
        }
      } else {
        debugPrint('SUBSCRIPTION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error creating subscription: $error');
      }
    }

    return false; // Return false on failure
  }
}
