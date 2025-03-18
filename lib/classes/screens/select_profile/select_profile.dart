import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/screens/register/register.dart';
import 'package:ride_card_app/classes/screens/select_profile/widgets/widget.dart';
import 'package:ride_card_app/classes/screens/welcome/welcome.dart';

class SelectProfileScreen extends StatefulWidget {
  const SelectProfileScreen({super.key, required this.strProfileSelect});

  final String strProfileSelect;

  @override
  State<SelectProfileScreen> createState() => _SelectProfileScreenState();
}

class _SelectProfileScreenState extends State<SelectProfileScreen> {
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
          widgetSelectProfileBG(),
          // LOGIN LOGO
          widgetSelectProfileLogo(),
          // HEADER
          widgetSelectProfileHeader(),
          // SUB HEADER
          widgetSelectProfileSubHeader(),
          // Positioned(
          //   top: 80.0,
          //   child: customNavigationBar(
          //     context,
          //     'Back',
          //   ),
          // ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  //
                  if (widget.strProfileSelect == '2') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(
                          strProfileIs: widget.strProfileSelect,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(
                          strProfileType: 'Member',
                          // strProfileIs: widget.strProfileSelect,
                        ),
                      ),
                    );
                  }
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
                      TEXT_USER,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(
                        strProfileType: 'Business',
                        // strProfileIs: widget.strProfileSelect,
                      ),
                    ),
                  );
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
                      TEXT_BUSINESS,
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
