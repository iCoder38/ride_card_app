import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

final ApiService _apiService = ApiService();
GenerateTokenService apiServiceGT = GenerateTokenService();

class ApiServiceForListOfAllCards {
  // final _apiService; // Initialize your API service here

  //ApiServiceForListOfAllCards(this._apiService);

  Future<List<dynamic>> listOfAllCards(BuildContext context) async {
    debugPrint('API ==> ADD CARD');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();

    final parameters = {
      'action': 'cardlist',
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

      if (kDebugMode) {
        print('STATUS ==> $successStatus');
        print(successMessage);
      }

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');
        if (successMessage == NOT_AUTHORIZED) {
          await apiServiceGT.generateToken(
            userId,
            FirebaseAuth.instance.currentUser!.email,
            roleIs,
          );
          return await listOfAllCards(context);
        } else {
          var arrAllCards = jsonResponse['data'] ?? [];
          debugPrint('YEAH DONE');
          if (kDebugMode) {
            print(arrAllCards);
          }
          return arrAllCards;
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
