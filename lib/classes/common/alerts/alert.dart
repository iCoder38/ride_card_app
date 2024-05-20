import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';

void showLoadingUI(BuildContext context, String message) async {
  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Center(
                child: textFontORBITRON(
                  //
                  message,
                  Colors.black,
                  16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
