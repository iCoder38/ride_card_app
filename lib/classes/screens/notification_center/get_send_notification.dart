import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/screens/notification_center/method.dart';

Future<List> getUserData(id) async {
  if (kDebugMode) {
    print(id);
  }
  final snapshot = await FirebaseFirestore.instance
      .collection(
        'MODE/TEST/RIDE_CARD_APP/USERS/LIST',
      )
      .where('userId', isEqualTo: id.toString())
      .get();
  return snapshot.docs;
}

getUserFullDataToSendNotification(storyAdminId) {
  getUserData(storyAdminId).then((v) {
    if (v[0]['deviceToken'] != null) {
      sendNotificationAndGetResponse(
        v[0]['deviceToken'],
        'Liked you story',
        loginUserName(),
        'liked your story. Tap to see.',
      );
    } else {
      Logger().d('DEVICE TOKEN IS NULL');
    }
  });
}

sendNotificationAndGetResponse(
  String tokenIs,
  String notificationTitle,
  String likerName,
  String messageBody,
) async {
  bool notificationResponse =
      await sendPushMessage(tokenIs, notificationTitle, likerName, messageBody);
  if (notificationResponse == true) {
    debugPrint('NOTIFICATION SENT SUCCESSFULLY');
  } else {
    debugPrint('NOTIFICATION NOT SENT');
  }
}
