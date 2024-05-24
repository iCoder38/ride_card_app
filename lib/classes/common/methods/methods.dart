import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

clearCache() {
  debugPrint('========');
  debugPrint('=======');
  debugPrint('======');
  debugPrint('=====');
  debugPrint('====');
  debugPrint('===');
  debugPrint('==');
  debugPrint('= CLEARED =');
  debugPrint('==');
  debugPrint('===');
  debugPrint('====');
  debugPrint('=====');
  debugPrint('======');
  debugPrint('=======');
  DefaultCacheManager manager = DefaultCacheManager();
  manager.emptyCache();
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut().then((value) => {
        //
      });
}

Future<dynamic> deviceIs() async {
  var deviceName = '';
  if (Platform.isAndroid) {
    deviceName = 'Android';
  } else {
    deviceName = 'iOS';
  }
  return deviceName;
}

// FIREBASE: GET CURRENT USER NAME
getCurrentUserName() {
  User? user = FirebaseAuth.instance.currentUser;
  return user!.displayName;
}

// FIREBASE: GET CURRENT USER EMAIL
getCurrentUserEmail() {
  User? user = FirebaseAuth.instance.currentUser;
  return user!.email;
}

// GENERATE RANDOM NUMBERS
String generateRandomString(int length) {
  const charset =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(
      length, (index) => charset[random.nextInt(charset.length)]).join();
}
