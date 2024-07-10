import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// Adjust the import according to your project structure
import 'package:firebase_auth/firebase_auth.dart';

final ApiService _apiService = ApiService();
GenerateTokenService apiServiceGT = GenerateTokenService();

class TransactionService {
  static var arrAllUser = [];

  static Future<List<dynamic>> recentTransaction(BuildContext context) async {
    debugPrint('API ==> RECENT TRANSACTION');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY) ?? '';
    var userId = prefs.getString('Key_save_login_user_id') ?? '';
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {
      'action': 'recenthistory',
      'userId': userId,
    };
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
      String successMessage = jsonResponse['msg'] ?? '';

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');

        if (successMessage == NOT_AUTHORIZED) {
          await apiServiceGT.generateToken(
            userId,
            FirebaseAuth.instance.currentUser!.email,
            roleIs,
          );
          return recentTransaction(context); // Retry the request
        } else {
          arrAllUser = jsonResponse['data'] ?? [];
          debugPrint('YEAH DONE');
          if (kDebugMode) {
            print(arrAllUser);
          }
          return arrAllUser;
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
        return [];
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return [];
    }
  }

  //
  static Future<List<dynamic>> transacctionHistory(BuildContext context) async {
    debugPrint('API ==> RECENT TRANSACTION');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY) ?? '';
    var userId = prefs.getString('Key_save_login_user_id') ?? '';
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {
      'action': 'transactionhistory',
      'userId': userId,
      'type': 'Add,Sent'
    };
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
      String successMessage = jsonResponse['msg'] ?? '';

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');

        if (successMessage == NOT_AUTHORIZED) {
          await apiServiceGT.generateToken(
            userId,
            FirebaseAuth.instance.currentUser!.email,
            roleIs,
          );
          return transacctionHistory(context); // Retry the request
        } else {
          arrAllUser = jsonResponse['data'] ?? [];
          debugPrint('YEAH DONE');
          if (kDebugMode) {
            print(arrAllUser);
          }
          return arrAllUser;
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
        return [];
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return [];
    }
  }

  //
  static Future<List<dynamic>> requestsHistoryAPI(
    BuildContext context,
    String type,
  ) async {
    debugPrint('API ==> REQUESTS TRANSACTION');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY) ?? '';
    var userId = prefs.getString('Key_save_login_user_id') ?? '';
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {
      'action': 'transactionhistory',
      'userId': userId,
      'type': type,
    };
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
      String successMessage = jsonResponse['msg'] ?? '';

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');

        if (successMessage == NOT_AUTHORIZED) {
          await apiServiceGT.generateToken(
            userId,
            FirebaseAuth.instance.currentUser!.email,
            roleIs,
          );
          return transacctionHistory(context); // Retry the request
        } else {
          arrAllUser = jsonResponse['data'] ?? [];
          debugPrint('YEAH DONE');
          if (kDebugMode) {
            print(arrAllUser);
          }
          return arrAllUser;
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
        return [];
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return [];
    }
  }
}
