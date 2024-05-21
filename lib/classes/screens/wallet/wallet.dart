import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/wallet/widgets/widgets.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        child: _UIKitWalletAfterBG(context),
      ),
    );
  }

  Widget _UIKitWalletAfterBG(context) {
    return Column(
      children: [
        const SizedBox(
          height: 80.0,
        ),
        customNavigationBarForMenu(TEXT_NAVIGATION_TITLE_WALLET, _scaffoldKey),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Row(
              children: [
                widgetWalletUpperDeckContainerLeft(),
                widgetWalletUpperDeckContainerRight(),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: textFontPOOPINS(
              'Recent transactions',
              Colors.orangeAccent,
              16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListTile(
          title: textFontPOOPINS(
            'Money added',
            Colors.white,
            18.0,
            fontWeight: FontWeight.w600,
          ),
          subtitle: textFontPOOPINS(
            'April 33, 2024',
            Colors.grey,
            12.0,
            fontWeight: FontWeight.w500,
          ),
          trailing: textFontORBITRON(
            '+220',
            Colors.greenAccent,
            18.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Divider(
          thickness: 0.2,
        )
      ],
    );
  }
}
