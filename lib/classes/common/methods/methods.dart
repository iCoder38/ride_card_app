import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ride_card_app/classes/screens/welcome/welcome.dart';
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

Future<void> signOut(context) async {
  await FirebaseAuth.instance.signOut().then((value) => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        )
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

String convertCentsToDollarsAsString(String centsString) {
  // Parse the cents string to an integer
  int cents = int.tryParse(centsString) ?? 0;

  // Convert cents to dollars (divide by 100)
  double dollars = cents / 100.0;

  // Format the dollars as a string with 2 decimal places
  String dollarString = dollars.toStringAsFixed(2);

  return '\$$dollarString';
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

String calculatePercentage(String amountStr) {
  // Parse the string amount to a double
  double amount = double.tryParse(amountStr) ?? 0.0;

  // Calculate 1.3% of the amount
  double percentage = amount * 0.013;

  // Return the deducted percentage amount as a string with 2 decimal places
  return percentage.toString();
  // percentage.toStringAsFixed(3);
}

Map<String, String> calculateAmountAndDeduction(
    String amountStr, double serverPercentage) {
  // Parse the string amount to a double
  double amount = double.tryParse(amountStr) ?? 0.0;

  // Convert the server percentage (e.g., 1.3%) to decimal form
  double convertedPercentage = serverPercentage / 100;

  // Calculate the deduction amount
  double deduction = amount * convertedPercentage;

  // Calculate the final amount after deduction
  double totalAfterDeduction = amount - deduction;

  // Return both the final amount and the deducted percentage amount as strings with 2 decimal places
  return {
    'finalAmount': totalAfterDeduction.toStringAsFixed(2),
    'deductionAmount': deduction.toStringAsFixed(2),
  };
}
