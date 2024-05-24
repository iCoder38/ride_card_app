import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateTokenService {
  Future<String> generateToken(userId, email, role) async {
    try {
      // Define your POST parameters here
      Map<String, dynamic> postData = {
        'action': 'gettoken',
        'userId': userId,
        'email': email,
        'role': role,
      };

      final httpResponse = await http.post(
        Uri.parse(BASE_URL),
        body: postData,
      );

      if (httpResponse.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(httpResponse.body);
        String token = jsonResponse['AuthToken'];
        // save token locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('key_save_token_locally', token);
        return token;
      } else {
        return 'Failed to load success response';
      }
    } catch (error) {
      return 'Error: $error';
    }
  }
}
