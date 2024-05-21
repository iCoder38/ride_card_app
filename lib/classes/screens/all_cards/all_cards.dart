import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/all_cards/widgets/widgets.dart';

class AllCardsScreen extends StatefulWidget {
  const AllCardsScreen({super.key});

  @override
  State<AllCardsScreen> createState() => _AllCardsScreenState();
}

class _AllCardsScreenState extends State<AllCardsScreen> {
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
        child: _UIKitManageCardsAfterBG(context),
      ),
    );
  }

  Widget _UIKitManageCardsAfterBG(context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        customNavigationBar(context, TEXT_NAVIGATION_TITLE_ALL_CARDS),
        const SizedBox(
          height: 40.0,
        ),
        widgetDummyCardShow(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: ListTile(
            title: textFontPOOPINS(
              '4*** | 3*** | 7*** | 9***',
              Colors.white,
              16.0,
              fontWeight: FontWeight.w600,
            ),
            subtitle: textFontPOOPINS(
              'Dishu - Debit Card',
              Colors.white,
              12.0,
            ),
            trailing: textFontORBITRON(
              'axis',
              Colors.orange,
              10.0,
            ),
            leading: const Icon(
              Icons.credit_card,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
