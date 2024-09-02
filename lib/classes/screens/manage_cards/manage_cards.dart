import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:u_credit_card/u_credit_card.dart';

class ManageCardsScreen extends StatefulWidget {
  const ManageCardsScreen({super.key});

  @override
  State<ManageCardsScreen> createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;
  bool isChatNotificationOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: _UIKit(context),
    );
  }

  Container _UIKit(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _UIKitManageCardsAfterBG(context),
      ),
    );
  }

  Widget _UIKitManageCardsAfterBG(context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        customNavigationBar(context, TEXT_NAVIGATION_TITLE_MANAGE_CARDS),
        const SizedBox(
          height: 40.0,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CreditCardUi(
              width: MediaQuery.of(context).size.width,
              cardHolderFullName: 'John Doe',
              cardNumber: '1234567812345678',
              validThru: '10/24',
              validFrom: '01/24',
              topLeftColor: Colors.blue,
              bottomRightColor: Colors.black,
              placeNfcIconAtTheEnd: true,
              enableFlipping: true,
              cvvNumber: '123',
              cardType: CardType.debit,
              cardProviderLogo: Image.asset('assets/images/logo.png')),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 24.0, left: 24.0),
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: textFontPOOPINS(
                      'Block/unblock',
                      Colors.black,
                      16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: FlutterSwitch(
                    width: 60.0,
                    height: 26.0,
                    valueFontSize: 12.0,
                    toggleSize: 22.0,
                    value: true,
                    borderRadius: 30.0,
                    padding: 4,
                    showOnOff: true,
                    onToggle: (val) {
                      setState(() {
                        isChatNotificationOn = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 24.0, left: 24.0),
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: textFontPOOPINS(
                      'Notifications',
                      Colors.black,
                      16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: FlutterSwitch(
                    width: 60.0,
                    height: 26.0,
                    valueFontSize: 12.0,
                    toggleSize: 22.0,
                    value: true,
                    borderRadius: 30.0,
                    padding: 4,
                    showOnOff: true,
                    onToggle: (val) {
                      setState(() {
                        isChatNotificationOn = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 24.0, left: 24.0),
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: textFontPOOPINS(
                      'Set PIN',
                      Colors.black,
                      16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                      color: appORANGEcolor,
                      borderRadius: BorderRadius.circular(
                        14.0,
                      ),
                    ),
                    child: Center(
                      child: textFontPOOPINS(
                        'PIN',
                        Colors.white,
                        14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
          ),
          child: GestureDetector(
            onTap: () {
              showLoadingUI(context, PLEASE_WAIT);
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: appREDcolor,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: Center(
                child: textFontPOOPINS(
                  //
                  'Cancel card',
                  Colors.white,
                  18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
