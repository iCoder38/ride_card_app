import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';

Widget customNavigationBar(title) {
  return Row(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(
            left: 16.0,
          ),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(
        width: 40.0,
      ),
      Container(
        height: 40,
        color: Colors.transparent,
        child: Center(
          child: textFontORBITRON(
            //
            title,
            Colors.white,
            18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
    ],
  );
}
