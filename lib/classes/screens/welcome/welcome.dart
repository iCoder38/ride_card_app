import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_bar/app_bar.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/screens/welcome/widgets/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBarScreen(
        str_app_bar_title: TEXT_NAVIGATION_TITLE_WELCOME,
        str_status: '0',
        showNavColor: false,
      ),*/
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover, // Make the image cover the whole screen
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 160.0),
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  24.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover, // Fit the image inside the container
                ),
              ),
            ),
          ),
          // const Spacer(),
          Positioned(
            bottom: 210,
            left: 0,
            right: 0,
            child: widgetLoginHeader(),
          ),
          Positioned(
            bottom: 180,
            left: 0,
            right: 0,
            child: widgetLoginSubHeader(),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: appREDcolor,
                  borderRadius: BorderRadius.circular(
                    14.0,
                  ),
                ), // 218 71 50
                child: Center(
                  child: textFontPOOPINS(
                    //
                    TEXT_SIGN_IN,
                    Colors.white,
                    18.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    14.0,
                  ),
                  border: Border.all(
                    color: const Color.fromRGBO(
                      243,
                      222,
                      76,
                      1,
                    ),
                    width: 5.0,
                  ),
                ), // 218 71 50
                child: Center(
                  child: textFontPOOPINS(
                    //
                    TEXT_CREATE_AN_ACCOUNT,
                    Colors.white,
                    18.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
