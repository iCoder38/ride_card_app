import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';

Widget widgetLoginHeader() {
  return Positioned(
    bottom: 210,
    left: 0,
    right: 0,
    child: Align(
      alignment: Alignment.center,
      child: textFontPOOPINS(
        //
        TEXT_WELCOME_TITLE,
        Colors.white,
        16.0,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget widgetLoginSubHeader() {
  return Positioned(
    bottom: 180,
    left: 0,
    right: 0,
    child: Align(
      alignment: Alignment.center,
      child: textFontPOOPINS(
        //
        TEXT_WELCOME_SUB_TITLE,
        Colors.white,
        14.0,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}

Widget widgetLoginLogo() {
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
      margin: const EdgeInsets.only(top: 160.0),
      height: 180,
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          24.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover, // Fit the image inside the container
        ),
      ),
    ),
  );
}

Widget widgetLoginBG() {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/background.png'),
        fit: BoxFit.cover, // Make the image cover the whole screen
      ),
    ),
  );
}
