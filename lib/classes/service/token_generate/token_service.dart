import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateTokenService {
  Future<dynamic> generateToken(userId, email, role) async {
    try {
      // Define your POST parameters here
      Map<String, dynamic> postData = {
        'action': 'gettoken',
        'userId': userId,
        'email': email,
        'role': role,
      };
      if (kDebugMode) {
        print(postData);
      }

      final httpResponse = await http.post(
        Uri.parse(BASE_URL),
        body: postData,
      );

      if (httpResponse.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(httpResponse.body);
        String token = jsonResponse['AuthToken'];
        if (kDebugMode) {
          print('the token you get from api');
          print(token);
        }
        // save token locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('key_save_token_locally', token);
        return token;
      } else {
        if (kDebugMode) {
          print('TOKEN API NOT WORKING');
        }
        return 'Failed to load success response';
      }
    } catch (error) {
      if (kDebugMode) {
        print('ERROR: ==> TOKEN API NOT WORKING');
      }
      return 'Error: $error';
    }
  }
}
