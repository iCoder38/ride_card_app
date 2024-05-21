// FONTS
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//
// TEXT
var TEXT_NAVIGATION_TITLE_WELCOME = 'welcome'.toUpperCase();
var TEXT_NAVIGATION_TITLE_REGISTRATION = 'register'.toUpperCase();
var TEXT_NAVIGATION_TITLE_COMPLETE_PROFILE = 'complete profile'.toUpperCase();
var TEXT_NAVIGATION_TITLE_DASHBOARD = 'dashboard'.toUpperCase();
var TEXT_NAVIGATION_TITLE_MANAGE_CARDS = 'manage cards'.toUpperCase();
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
var TEXT_FIELD_EMPTY_TEXT = 'Please enter value';
var TEXT_FIELD_KYC =
    'Please select and upload documents to complete your KYC verification process.';

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
var TEXT_MENU_MANAGE_CARDS = 'Manage cards';
var TEXT_MENU_SENT_MONEY = 'Sent money';
var TEXT_MENU_WALLET = 'Wallet';
var TEXT_MENU_CREDIT_SCORE = 'Credit score';
var TEXT_MENU_SETTINGS = 'Settings';
var TEXT_MENU_HISTORY = 'History';
var TEXT_MENU_CHANGE_PASSWORD = 'Change password';
var TEXT_MENU_HELP = 'Help';
var TEXT_MENU_LOGOUT = 'Logout';

// COLOR
var appNAVcolor = const Color.fromARGB(200, 0, 0, 0);
var appBGcolor = const Color.fromARGB(200, 0, 0, 0);
var appREDcolor = const Color.fromRGBO(218, 72, 50, 1);

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
