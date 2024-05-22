// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/screens/bottom_bar/bottom_bar.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(
        //       "assets/images/background.png",
        //     ),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            /*DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),*/
            const SizedBox(
              height: 80,
            ),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromRGBO(
                229,
                135,
                60,
                1,
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 6.0,
                  ),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        40.0,
                      ),
                      child: Image.asset(
                        'assets/images/background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: textFontOPENSANS(
                          'Dishant Rajput',
                          Colors.black,
                          16.0,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: textFontOPENSANS(
                          '@username',
                          Colors.black,
                          12.0,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_DASHBOARD,
                Colors.black,
                16.0,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomBar(selectedIndex: 0)),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.credit_card,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_MANAGE_CARDS,
                Colors.black,
                16.0,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.attach_money_outlined,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_SENT_MONEY,
                Colors.black,
                16.0,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.wallet,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_WALLET,
                Colors.black,
                16.0,
              ),
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomBar(selectedIndex: 1)),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.score,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_CREDIT_SCORE,
                Colors.black,
                16.0,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_SETTINGS,
                Colors.black,
                16.0,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.file_copy,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_HISTORY,
                Colors.black,
                16.0,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.lock,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_CHANGE_PASSWORD,
                Colors.black,
                16.0,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.help,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_HELP,
                Colors.black,
                16.0,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_LOGOUT,
                Colors.black,
                16.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
