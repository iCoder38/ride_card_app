import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class FirebaseAuthNotificationService {
  final _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final _jsonFilePath = 'assets/images/rideCardAppNotificationServiceKey.json';
  //
  //
  Future<String> getAccessToken() async {
    // Load the service account key JSON file
    final jsonString = await rootBundle.loadString(_jsonFilePath);
    final jsonMap = jsonDecode(jsonString);

    // Create the credentials
    final accountCredentials = ServiceAccountCredentials.fromJson(jsonMap);

    // Get the access token
    final client = await clientViaServiceAccount(accountCredentials, _scopes);
    final accessToken = client.credentials.accessToken.data;

    // Close the client to free resources
    client.close();

    return accessToken;
  }
}

void sendNotificationNewDummy(String token, String title, String body) async {
  String firebaseUrl =
      'https://fcm.googleapis.com/v1/projects/ride-card-app/messages:send';
  String serviceAccountJson =
      'assets/images/rideCardAppNotificationServiceKey.json';

  // Load service account credentials and create an authenticated client
  var credentials = auth.ServiceAccountCredentials.fromJson(serviceAccountJson);
  var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  auth.clientViaServiceAccount(credentials, scopes).then((httpClient) async {
    var payload = {
      "message": {
        "token": token,
        "notification": {"title": title, "body": body},
        "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "status": "done"}
      }
    };

    var response = await httpClient.post(
      Uri.parse(firebaseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (kDebugMode) {
      print('FCM Response: ${response.body}');
    }

    httpClient.close();
  });
}
