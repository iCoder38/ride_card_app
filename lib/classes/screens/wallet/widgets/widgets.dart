import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/screens/wallet/add_money/add_money.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/send_money.dart';

Widget widgetWalletUpperDeckContainerLeft(context, walletBalance) {
  String formattedDate = DateFormat('MMMM dd yyyy').format(DateTime.now());
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
            //
            formattedDate,
            Colors.grey,
            14.0,
          ),
          Expanded(
            child: walletBalance == ''
                ? textFontPOOPINS(
                    "\$0",
                    Colors.red,
                    28.0,
                    fontWeight: FontWeight.w900,
                  )
                : textFontPOOPINS(
                    "\$$walletBalance",
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

Widget widgetWalletUpperDeckContainerRight(context) {
  return Expanded(
    child: Container(
      height: 120,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              //
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SendMoneyScreen(
                    menuBar: 'no',
                  ),
                ),
              );
            },
            child: Container(
              height: 40,
              width: 130,
              decoration: BoxDecoration(
                color: hexToColor(appORANGEcolorHexCode),
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
          ),
          const SizedBox(
            height: 6,
          ),
          GestureDetector(
            onTap: () {
              //
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMoneyScreen(),
                ),
              );
            },
            child: Container(
              height: 40,
              width: 130,
              decoration: BoxDecoration(
                color: hexToColor(appREDcolorHexCode),
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
            ),
          )
        ],
      ),
    ),
  );
}
