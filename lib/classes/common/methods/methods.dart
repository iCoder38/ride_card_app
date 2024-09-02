import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

// convert sv date to custom date
String formatDate(String inputDateStr) {
  // Convert input date string to DateTime object
  DateTime inputDate = DateTime.parse(inputDateStr);

  // Format DateTime object to desired format
  String formattedDate = DateFormat('MMMM dd, yyyy').format(inputDate);

  return formattedDate;
}

String convertCentsToDollarsAndCents(String centsString) {
  // Parse the cents value from string to integer
  int cents = int.tryParse(centsString) ?? 0;

  // Calculate dollars and cents
  int dollars = cents ~/ 100;
  int remainingCents = cents % 100;

  // Build the result string
  String result =
      // '${dollars.toString()} dollars and ${remainingCents.toString()} cents';
      '${dollars.toString()}.${remainingCents.toString()}';

  return result;
}

double convertDollarToCentsInDouble(double cents) {
  double dollars = cents / 100.0;
  return dollars;
}

String convertDollarsToCentsAsString(String dollarString) {
  // Remove any commas or currency symbols if present
  dollarString = dollarString.replaceAll(',', '').replaceAll('\$', '');

  // Parse the dollar amount from string to double
  double dollars = double.tryParse(dollarString) ?? 0.0;

  // Convert dollars to cents (multiply by 100 and round to nearest integer)
  int cents = (dollars * 100).round();

  // Format cents as a string
  String centsString = cents.toString();

  return centsString;
}

String loginUserName() {
  String userName = FirebaseAuth.instance.currentUser!.displayName.toString();
  return userName;
}

String loginUserId() {
  String userId = FirebaseAuth.instance.currentUser!.uid.toString();
  return userId;
}

String loginUserEmail() {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  return email;
}

Future<String> loginUserType() async {
  var roleIs = '';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  roleIs = prefs.getString('key_save_user_role').toString();

  return getUserRole2();
}

String getUserRole2() {
  return 'test';
}

// ip address of device
Future<String?> getIPAddress() async {
  final info = NetworkInfo();
  String? ipAddress = await info.getWifiIP();
  ipAddress ??= await info.getWifiIPv6();
  return ipAddress;
}
