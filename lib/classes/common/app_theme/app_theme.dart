// FONTS
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//
// TEXT
var TEXT_NAVIGATION_TITLE_WELCOME = 'welcome'.toUpperCase();
var TEXT_NAVIGATION_TITLE_REGISTRATION = 'register'.toUpperCase();
var TEXT_NAVIGATION_TITLE_COMPLETE_PROFILE = 'complete profile'.toUpperCase();
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
