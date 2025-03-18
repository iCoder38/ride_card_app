import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ride_card_app/classes/screens/notification_center/service.dart';

Future<dynamic> sendPushMessage(
  String token,
  String title,
  String likerName,
  String body1,
) async {
  var body = '$likerName $body1';
  try {
    final authService = FirebaseAuthNotificationService();
    final serverToken = await authService.getAccessToken();

    var projectId = 'ride-card-app';
    Logger().d(projectId);
    final response = await http.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'message': {
            'token': token,
            'notification': {
              'title': title,
              'body': body,
            },
            'android': {
              'notification': {
                'sound': 'default',
              },
            },
            'apns': {
              'payload': {
                'aps': {
                  'alert': {
                    'title': title,
                    'body': body,
                  },
                  "content-available": 1,
                  'sound': 'default',
                },
              },
            },
          },
        },
      ),
    );

    if (response.statusCode == 200) {
      debugPrint('Message sent successfully');
      return true;
    } else {
      if (kDebugMode) {
        print('Failed to send message: ${response.statusCode}');
        print('Response: ${response.body}');
      }

      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error sending message: $e');
    }
    return false;
  }
}
