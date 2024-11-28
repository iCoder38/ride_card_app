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
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20.0),
                  textFontPOOPINS(
                    message,
                    Colors.black,
                    14.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
