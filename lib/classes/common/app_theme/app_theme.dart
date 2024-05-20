// FONTS
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//
// TEXT
var TEXT_NAVIGATION_TITLE_WELCOME = 'welcome'.toUpperCase();
var TEXT_NAVIGATION_TITLE_REGISTRATION = 'register'.toUpperCase();
//
// COLOR
var appNAVcolor = const Color.fromARGB(200, 0, 0, 0);
var appBGcolor = const Color.fromARGB(200, 0, 0, 0);
var appREDcolor = const Color.fromRGBO(218, 72, 50, 1);
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
// ALERT TEXT
var PLEASE_WAIT = 'Please wait...';

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
