import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ride_card_app/classes/common/hive/hive.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';

final ApiService _apiService = ApiService();
GenerateTokenService _apiServiceGT = GenerateTokenService();
Future<dynamic> sendRequestToProfileDynamic() async {
  debugPrint('API ==> PROFILE');
  var name = '';
  var contactNumber = '';

  var box = await Hive.openBox<MyData>(HIVE_BOX_KEY);
  var myData = box.getAt(0);
  await box.close();

  final parameters = {
    'action': 'profile',
    'userId': myData!.userId,
  };
  if (kDebugMode) {
    print(parameters);
  }

  try {
    final response = await _apiService.postRequest(parameters, '');
    if (kDebugMode) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      // String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];

      if (successMessage == NOT_AUTHORIZED) {
        await _apiServiceGT.generateToken(
          myData.userId,
          FirebaseAuth.instance.currentUser!.email,
          myData.role,
        );
        return await sendRequestToProfileDynamic();
      } else {
        debugPrint('PROFILE: RESPONSE ==> SUCCESS');
        return jsonResponse;
      }
    } else {
      debugPrint('PROFILE: RESPONSE ==> FAILURE');
      return null;
    }
  } catch (error) {
    debugPrint('Error: $error');
    return null;
  }
}
