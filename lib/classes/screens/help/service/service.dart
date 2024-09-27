import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// import 'package:hive/hive.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ApiService _apiService = ApiService();
GenerateTokenService _apiServiceGT = GenerateTokenService();
Future<dynamic> helpApi() async {
  debugPrint('API ==> HELP');
  SharedPreferences prefs2 = await SharedPreferences.getInstance();
  var token = prefs2.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
  var userID = prefs2.getString('Key_save_login_user_id').toString();
  var roleIs = '';
  roleIs = prefs2.getString('key_save_user_role').toString();
  final parameters = {
    'action': 'help',
  };
  // await box.close();
  if (kDebugMode) {
    print(parameters);
  }

  try {
    final response = await _apiService.postRequest(parameters, token);
    if (kDebugMode) {
      // print(response.body);
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      // String successStatus = jsonResponse['status'];
      //  String data = jsonResponse['data'];
      // String successMessage = jsonResponse['msg'];

      if (kDebugMode) {
        print(jsonResponse);
        // print(data);
      }

      /*if (successMessage == NOT_AUTHORIZED) {
        await _apiServiceGT.generateToken(
          userID.toString(),
          FirebaseAuth.instance.currentUser!.email,
          roleIs,
        );
        return await helpApi();
      } else {*/
      debugPrint('PROFILE: RESPONSE ==> SUCCESS');
      return jsonResponse;
      // }
    } else {
      debugPrint('PROFILE: RESPONSE ==> FAILURE');
      return null;
    }
  } catch (error) {
    debugPrint('Error: $error');
    return null;
  }
}
