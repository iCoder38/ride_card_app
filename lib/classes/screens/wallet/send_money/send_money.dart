import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: _UIKitSendMoneyAfterBG(context),
      ),
    );
  }

  Widget _UIKitSendMoneyAfterBG(context) {
    return Column(
      children: [
        const SizedBox(
          height: 80,
        ),
        customNavigationBar(context, TEXT_NAVIGATION_TITLE_SEND_MONEY),
        textFontPOOPINS(
          'Recents',
          hexToColor(appREDcolorHexCode),
          16.0,
          fontWeight: FontWeight.w800,
        ),
        textFontPOOPINS(
          'Contacts',
          hexToColor(appREDcolorHexCode),
          16.0,
          fontWeight: FontWeight.w800,
        ),
      ],
    );
  }
}
