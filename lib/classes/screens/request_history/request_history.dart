import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';

class RequestHistoryScreen extends StatefulWidget {
  const RequestHistoryScreen({super.key, required this.menuBar});

  final String menuBar;

  @override
  State<RequestHistoryScreen> createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
        color: Colors.amber,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _UIKitRequestHistoryAfterBG(context),
      ),
    );
  }

  Widget _UIKitRequestHistoryAfterBG(context) {
    return Column(
      children: [
        const SizedBox(
          height: 80.0,
        ),
        customNavigationBarForMenu(
          TEXT_NAVIGATION_TITLE_REQUEST_HISTORY,
          _scaffoldKey,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 20.0,
          ),
          child: Container(
            // height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                16.0,
              ),
            ),
            child: ListTile(
              leading: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
              ),
              title: textFontPOOPINS(
                'Dishant rajput',
                Colors.black,
                18.0,
                fontWeight: FontWeight.w800,
              ),
              subtitle: textFontPOOPINS(
                '+91-8287632340',
                Colors.black,
                12.0,
                fontWeight: FontWeight.w500,
              ),
              trailing: Container(
                height: 30,
                width: 60,
                decoration: BoxDecoration(
                  color: hexToColor(appGREENcolorHexCode),
                  borderRadius: BorderRadius.circular(
                    14.0,
                  ),
                ),
                child: Center(
                  child: textFontPOOPINS(
                    '\$200',
                    Colors.white,
                    14.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
