import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
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
        child: _UIKitSUCCESSAfterBG(context),
      ),
    );
  }

  Widget _UIKitSUCCESSAfterBG(context) {
    return Column(
      children: [
        const SizedBox(
          height: 80.0,
        ),
        customNavigationBar(
          context,
          TEXT_NAVIGATION_TITLE_SUCCESS,
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
              color: hexToColor(appORANGEcolorHexCode),
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
                Colors.white,
                18.0,
                fontWeight: FontWeight.w800,
              ),
              subtitle: textFontPOOPINS(
                '+91-8287632340',
                Colors.white,
                12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 60.0,
        ),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(
              50.0,
            ),
          ),
          child: Image.asset('assets/images/payment.png'),
        ),
        const SizedBox(
          height: 60.0,
        ),
        textFontPOOPINS(
          'Sent successfully to Dishant rajput',
          Colors.white,
          16.0,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 20.0,
        ),
        textFontPOOPINS(
          '\$100.00',
          hexToColor(appORANGEcolorHexCode),
          36.0,
          fontWeight: FontWeight.w800,
        ),
        const SizedBox(
          height: 40.0,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Divider(
            thickness: 0.4,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textFontPOOPINS(
              'Transaction done on',
              Colors.white,
              14.0,
              fontWeight: FontWeight.w400,
            ),
            textFontPOOPINS(
              ' 06 MARCH 2024',
              hexToColor(appORANGEcolorHexCode),
              14.0,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textFontPOOPINS(
              'Your trasaction id is',
              Colors.white,
              12.0,
              fontWeight: FontWeight.w400,
            ),
            textFontPOOPINS(
              ' 03040504',
              hexToColor(appORANGEcolorHexCode),
              12.0,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SuccessScreen()),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: hexToColor(appREDcolorHexCode),
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  child: Center(
                    child: textFontPOOPINS(
                      'Make another payment',
                      Colors.white,
                      18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SuccessScreen()),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: hexToColor(appORANGEcolorHexCode),
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.share_outlined,
                          size: 22.0,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        textFontPOOPINS(
                          'Make another payment',
                          Colors.white,
                          18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
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
