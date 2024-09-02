import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthServiceForChangePassword {
  Future<String> changePassword(
      String newPassword,
      String reEnterPassword,
      String oldPassword,
      Function showLoadingUI,
      Function customToast,
      Function dismissKeyboard,
      BuildContext context) async {
    if (newPassword != reEnterPassword) {
      dismissKeyboard(context);
      customToast(
          'Password not matched', Colors.redAccent, ToastGravity.BOTTOM);
      return 'failure';
    }

    showLoadingUI(context, 'updating...');
    debugPrint('API ==> CHANGE PASSWORD');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();

    final parameters = {
      'action': 'changepassword',
      'userId': userId,
      'newPassword': newPassword,
      'oldPassword': oldPassword,
    };
    if (kDebugMode) {
      print(parameters);
    }

    try {
      final response = await _postRequest(parameters, token);
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
        debugPrint('CHANGE PASSWORD: RESPONSE ==> SUCCESS');
        if (successMessage == NOT_AUTHORIZED) {
          // Handle token generation and retry logic

          return 'unauthorized';
        } else if (successStatus == 'Fails') {
          customToast(successMessage, Colors.redAccent, ToastGravity.BOTTOM);
          return successMessage;
        } else {
          // customToast(successMessage, Colors.green, ToastGravity.BOTTOM);
          return successMessage;
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('CHANGE PASSWORD: RESPONSE ==> FAILURE');
        return 'failure';
      }
    } catch (error) {
      customToast('An error occurred', Colors.redAccent, ToastGravity.TOP);
      return 'failure';
    }
  }

  Future<http.Response> _postRequest(
      Map<String, String> parameters, String token) async {
    final uri = Uri.parse(BASE_URL);
    return await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(parameters),
    );
  }
}
