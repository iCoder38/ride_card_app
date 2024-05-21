import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';

Widget widgetWalletUpperDeckContainerLeft() {
  return Expanded(
    child: Container(
      height: 120,
      color: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          textFontPOOPINS(
            'Balance',
            Colors.black,
            16.0,
            fontWeight: FontWeight.w600,
          ),
          textFontPOOPINS(
            'March 6, 2024',
            Colors.grey,
            14.0,
          ),
          Expanded(
            child: textFontPOOPINS(
              "\$15,000",
              Colors.red,
              28.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget widgetWalletUpperDeckContainerRight() {
  return Expanded(
    child: Container(
      height: 120,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 130,
            decoration: BoxDecoration(
              color: appORANGEcolor,
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Center(
              child: textFontPOOPINS(
                'Send',
                Colors.white,
                16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Container(
            height: 40,
            width: 130,
            decoration: BoxDecoration(
              color: appREDcolor,
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Center(
              child: textFontPOOPINS(
                'Add money',
                Colors.white,
                16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
