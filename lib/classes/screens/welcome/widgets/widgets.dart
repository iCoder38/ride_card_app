import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';

Widget widgetLoginHeader() {
  return Align(
    alignment: Alignment.center,
    child: textFontPOOPINS(
      //
      TEXT_WELCOME_TITLE,
      Colors.white,
      16.0,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget widgetLoginSubHeader() {
  return Align(
    alignment: Alignment.center,
    child: textFontPOOPINS(
      //
      TEXT_WELCOME_SUB_TITLE,
      Colors.white,
      14.0,
      fontWeight: FontWeight.w400,
    ),
  );
}
