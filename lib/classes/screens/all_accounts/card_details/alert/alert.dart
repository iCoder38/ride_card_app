import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';

void areYouSureFreezeCardPopup(
  BuildContext context, {
  required String type,
  required String message,
  required VoidCallback onDismiss,
  required VoidCallback onFreeze,
}) async {
  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: textFontPOOPINS(
                    message,
                    Colors.black,
                    18.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onDismiss();
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: textFontPOOPINS(
                          'Dismiss',
                          Colors.grey,
                          12.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onFreeze();
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: type == '1'
                            ? textFontPOOPINS(
                                'Freeze',
                                Colors.white,
                                14.0,
                              )
                            : textFontPOOPINS(
                                'Unfreeze',
                                Colors.white,
                                14.0,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void areYouSureCloseCardPopup(
  BuildContext context, {
  required String message,
  required String subMessage,
  required double showConvenienceFees,
  required VoidCallback onDismiss,
  required VoidCallback onFreeze,
}) async {
  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: textFontPOOPINS(
                    message,
                    Colors.black,
                    18.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      textFontPOOPINS(
                        subMessage,
                        Colors.black,
                        12.0,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: textFontPOOPINS(
                          //
                          '\nConvenience fee: \$$showConvenienceFees',
                          Colors.black,
                          12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onDismiss();
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: textFontPOOPINS(
                          'Dismiss',
                          Colors.grey,
                          12.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onFreeze();
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: textFontPOOPINS(
                          'Close',
                          Colors.white,
                          14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
