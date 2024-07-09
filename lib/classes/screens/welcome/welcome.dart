import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/login/login.dart';
import 'package:ride_card_app/classes/screens/register/register.dart';
import 'package:ride_card_app/classes/screens/register_complete_profile/business/business_complete_profile.dart';
import 'package:ride_card_app/classes/screens/welcome/widgets/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, this.strProfileType});

  final strProfileType;

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
          // BG COLOR
          widgetLoginBG(),
          // LOGIN LOGO
          widgetLoginLogo(),
          // HEADER
          widgetLoginHeader(),
          // SUB HEADER
          widgetLoginSubHeader(),
          Positioned(
            top: 80.0,
            child: customNavigationBar(
              context,
              'Back',
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  debugPrint('==> SIGN IN <==');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const SelectProfileScreen(
                  //       strProfileSelect: '2',
                  //     ),
                  //   ),
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
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
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  debugPrint('==> CREATE AN ACCOUNT <==');
                  if (strProfileType == 'Business') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const BusinessCompleteProfileScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(
                          strProfileIs: strProfileType,
                        ),
                      ),
                    );
                  }
                },
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
                      width: 4.0,
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
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
