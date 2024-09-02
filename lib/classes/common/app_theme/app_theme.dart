// FONTS
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

// SAVE HIVE KEY DEFAULT
var KEY_SAVE_DEFAULT = 'key_save_data2';
//
var DOLLAR_SIGN = '\$';
// TEXT
var TEXT_NAVIGATION_TITLE_WELCOME = 'welcome'.toUpperCase();
var TEXT_NAVIGATION_TITLE_REGISTRATION = 'register'.toUpperCase();
var TEXT_NAVIGATION_TITLE_COMPLETE_PROFILE = 'complete profile'.toUpperCase();
var TEXT_NAVIGATION_TITLE_DASHBOARD = 'dashboard'.toUpperCase();
var TEXT_NAVIGATION_TITLE_MANAGE_CARDS = 'manage cards'.toUpperCase();
var TEXT_NAVIGATION_TITLE_ALL_CARDS = 'all cards'.toUpperCase();
var TEXT_NAVIGATION_TITLE_WALLET = 'Wallet'.toUpperCase();
var TEXT_NAVIGATION_TITLE_ADD_MONEY = 'add money'.toUpperCase();
var TEXT_NAVIGATION_TITLE_SEND_MONEY = 'send / request money'.toUpperCase();
var TEXT_NAVIGATION_TITLE_SUCCESS = 'success'.toUpperCase();
var TEXT_NAVIGATION_TITLE_REQUEST_MONEY = 'request money'.toUpperCase();
var TEXT_NAVIGATION_TITLE_REQUEST_HISTORY = 'request history'.toUpperCase();
var TEXT_NAVIGATION_TITLE_STATEMENT = 'statement'.toUpperCase();
var TEXT_NAVIGATION_TITLE_ACCOUNTS = 'accounts'.toUpperCase();
var TEXT_NAVIGATION_TITLE_ACCOUNTS_DETAILS = 'Account details'.toUpperCase();
var TEXT_NAVIGATION_TITLE_CARDS_DETAILS = 'Card details'.toUpperCase();
//
var TEXT_SIGN_IN = 'sign in'.toUpperCase();
var TEXT_CREATE_AN_ACCOUNT = 'create an account'.toUpperCase();
var TEXT_WELCOME_TITLE = 'Welcome to Ride Card App';
var TEXT_WELCOME_SUB_TITLE = 'Choose an option to continue';
//
var TEXT_USER = 'user'.toUpperCase();
var TEXT_BUSINESS = 'business'.toUpperCase();
var TEXT_SUB_TITLE = 'Continue your account as a';
//
var TEXT_ALREADY_ACCOUNT = 'Already have an account? -';
//
var TEXT_ACCEPT_TERMS =
    'I have no objection in case Ride Card App seeks to authenticate the identity information provided by me is correct.';
// ALERT TEXT
var PLEASE_WAIT = 'Please wait...';
var CHECKING_SCORE_TEXT = 'checking...';
var TEXT_FIELD_EMPTY_TEXT = 'Please enter value';
var TEXT_FIELD_KYC =
    'Please select and upload documents to complete your KYC verification process.';
var TEXT_ALREADY_BEEN_EXIST =
    'This account is already been exist. Please enter different email id.';
var TEXT_F_ERROR =
    'Something went wrong. Please try again after sometime. code: F_2024';

// IMAGE
var BACKGROUNG_IMAGE_ASSET_URL = 'assets/images/background.png';

// SCREEN: CARDS
var TEXT_CREDIT_SCORE = 'Credit Score';
var TEXT_MANAGE_CARDS = 'Manage cards';
var TEXT_SEND_MONEY = 'Send money';
var TEXT_WALLER = 'Wallet';
var TEXT_STATEMENT = 'Statement';

// SCREEN: MENU
var TEXT_MENU_DASHBOARD = 'Dashboard';
var TEXT_MENU_EDIT_PROFILE = 'Edit profile';
var TEXT_MENU_MANAGE_CARDS = 'Manage cards';
var TEXT_MENU_SENT_MONEY = 'Send / Request money';
var TEXT_MENU_WALLET = 'Wallet';
var TEXT_MENU_CREDIT_SCORE = 'Credit score';
var TEXT_MENU_SETTINGS = 'Settings';
var TEXT_MENU_HISTORY = 'History';
var TEXT_MENU_CHANGE_PASSWORD = 'Change password';
var TEXT_MENU_HELP = 'Help';
var TEXT_MENU_LOGOUT = 'Logout';

// SCREEN: ADD MONEY
var TEXT_CURRENT_BALANCE = 'Current balance';
var TEXT_SELECT_AMOUNT = 'Select amount';
var TEXT_SELECT_AMOUNT_SUB_TITLE = 'Make sure to check target amount';
var TEXT_SELECT_CARD_TITLE = 'Select debit card';
var TEXT_SELECT_CARD_SUB_TITLE = 'Select debit card to add form';
var TEXT_PROCCED = 'Proceed';

// COLOR
var appNAVcolor = const Color.fromARGB(200, 0, 0, 0);
var appBGcolor = const Color.fromARGB(200, 0, 0, 0);
var appREDcolor = const Color.fromRGBO(218, 72, 50, 1);
var appORANGEcolor = const Color.fromRGBO(233, 153, 68, 1);

// code
var appREDcolorHexCode = '#ed3522';
var appORANGEcolorHexCode = '#ffa430';
var appGREENcolorHexCode = '#26d874';

// convert
// Utility function to convert hex color string to Color object
Color hexToColor(String hexString) {
  // Remove the hash symbol if present
  hexString = hexString.replaceAll('#', '');

  // If the hex code doesn't include alpha value, add 'FF' for full opacity
  if (hexString.length == 6) {
    hexString = 'FF$hexString';
  }

  // Convert the hex string to an integer and create a Color object
  return Color(int.parse(hexString, radix: 16));
}

// SVG IMAGES
var svgPath = 'assets/images/svg';
var formatSVG = 'svg';
Widget svgImage(imageName, height, width) {
  return SvgPicture.asset(
    '$svgPath/$imageName.$formatSVG',
    height: height,
    width: width,
    // color: Colors.pink,
  );
}

// FONT
Text textFontPOOPINS(text, color, size, {FontWeight? fontWeight}) {
  return Text(
    text.toString(),
    style: GoogleFonts.poppins(
      color: color,
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
  );
}

Text textFontOPENSANS(text, color, size, {FontWeight? fontWeight}) {
  return Text(
    text.toString(),
    style: GoogleFonts.openSans(
      color: color,
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
  );
}

Text textFontOPENSANScondence(text, color, size, {FontWeight? fontWeight}) {
  return Text(
    text.toString(),
    style: GoogleFonts.openSansCondensed(
      color: color,
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
  );
}

// APP FONTS
Text textFontORBITRON(text, color, size, {FontWeight? fontWeight}) {
  return Text(
    text.toString(),
    style: GoogleFonts.orbitron(
      color: color,
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
  );
}

// TOAST
customToast(message, COLOR, LOCATION) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: LOCATION,
      timeInSecForIosWeb: 2,
      backgroundColor: COLOR,
      textColor: Colors.white,
      fontSize: 14.0);
}

ShimmerLoader(
    {required double width,
    double? height,
    Color? color,
    Decoration? decoration}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      decoration: decoration,
      width: width,
      height: height ?? 10,
      color: color ?? Colors.white,
    ),
  );
}

// center progress indicator
Widget customCircularProgressIndicator({Color color = Colors.white}) {
  return Center(
    child: CircularProgressIndicator(
      color: color,
    ),
  );
}

// dismiss keyboard
void dismissKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
