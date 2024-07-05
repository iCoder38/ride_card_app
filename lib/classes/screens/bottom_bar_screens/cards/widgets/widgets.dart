import 'package:flutter/material.dart';

import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/screens/all_accounts/all_accounts.dart';

import 'package:ride_card_app/classes/screens/bottom_bar/bottom_bar.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/send_money.dart';

Widget widgetDashboardUpperDeck(context) {
  return Row(
    children: [
      const SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: GestureDetector(
          onTap: () {
            //
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AllAccountsScreen()),
            );
          },
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1E1E1E), // Darker color
                  Color(0xFF3C3C3C), // Slightly lighter color
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: Image.asset(
                      'assets/images/menu_cards.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                textFontPOOPINS(
                  //
                  'Manage accounts',
                  Colors.white,
                  16.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: GestureDetector(
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
            height: 180,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1E1E1E), // Darker color
                  Color(0xFF3C3C3C), // Slightly lighter color
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: Image.asset(
                      'assets/images/menu_send_money.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                textFontPOOPINS(
                  //
                  TEXT_SEND_MONEY,
                  Colors.white,
                  18.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 20.0,
      ),
    ],
  );
}

Widget widgetDashbaordLowerDeck(context) {
  return Row(
    children: [
      const SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomBar(
                  selectedIndex: 2,
                ),
              ),
            );
          },
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1E1E1E), // Darker color
                  Color(0xFF3C3C3C), // Slightly lighter color
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: Image.asset(
                      'assets/images/menu_wallet.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                textFontPOOPINS(
                  //
                  TEXT_WALLER,
                  Colors.white,
                  18.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomBar(
                  selectedIndex: 3,
                ),
              ),
            );
          },
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1E1E1E), // Darker color
                  Color(0xFF3C3C3C), // Slightly lighter color
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: Image.asset(
                      'assets/images/menu_statement.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                textFontPOOPINS(
                  //
                  TEXT_STATEMENT,
                  Colors.white,
                  18.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 20.0,
      ),
    ],
  );
}
