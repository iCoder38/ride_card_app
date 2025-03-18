// custom_drawer.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/screens/all_cards/add_card/add_card.dart';
import 'package:ride_card_app/classes/screens/all_cards/all_cards.dart';
import 'package:ride_card_app/classes/screens/bank/list.dart';
import 'package:ride_card_app/classes/screens/bottom_bar/bottom_bar.dart';
import 'package:ride_card_app/classes/screens/change_password/change_password.dart';
import 'package:ride_card_app/classes/screens/edit_profile/edit_profile.dart';
import 'package:ride_card_app/classes/screens/help/help.dart';
import 'package:ride_card_app/classes/screens/welcome/welcome.dart';
import 'package:ride_card_app/classes/screens/withdraw/withdraw.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  //
  var displayProfilePicture = '';

  @override
  void initState() {
    //
    localData();
    super.initState();
  }

  localData() async {
    debugPrint('== LOCAL DATA ==');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    displayProfilePicture =
        prefs.getString('Key_save_login_profile_picture').toString();
    setState(() {
      if (kDebugMode) {
        print(displayProfilePicture);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/orange_gradient_horizontal.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
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
              color: hexToColor(appORANGEcolorHexCode),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        child: CachedNetworkImage(
                          memCacheHeight: 600,
                          memCacheWidth: 600,
                          imageUrl: displayProfilePicture,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => SizedBox(
                            height: 40,
                            width: 40,
                            child: ShimmerLoader(
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          errorWidget: (context, url, error) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      /*child: Image.asset(
                        'assets/images/orange_gradient_horizontal.png',
                        fit: BoxFit.cover,
                      ),*/
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
                        child: textFontPOOPINS(
                          //
                          getCurrentUserName(),
                          Colors.white,
                          18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      /*Align(
                        alignment: Alignment.centerLeft,
                        child: textFontOPENSANS(
                          '@username',
                          Colors.black,
                          12.0,
                        ),
                      )*/
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_DASHBOARD,
                Colors.white,
                16.0,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomBar(
                      selectedIndex: 0,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_EDIT_PROFILE,
                Colors.white,
                16.0,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: const Icon(
            //     Icons.credit_card,
            //     color: Colors.white,
            //   ),
            //   title: textFontPOOPINS(
            //     //
            //     TEXT_MENU_MANAGE_CARDS,
            //     Colors.white,
            //     16.0,
            //   ),
            // ),
            ListTile(
              leading: const Icon(
                Icons.add_card_rounded,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                'Add external card',
                Colors.white,
                16.0,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCardScreen(
                      strMenuBack: 'no',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.account_balance,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                'Bank accounts',
                Colors.white,
                16.0,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllBanksScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.calendar_view_day_sharp,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                'All external cards',
                Colors.white,
                16.0,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllCardsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.attach_money_outlined,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_SENT_MONEY,
                Colors.white,
                16.0,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomBar(
                      selectedIndex: 1,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_WALLET,
                Colors.white,
                16.0,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomBar(selectedIndex: 2)),
                );
              },
            ),
            /*ListTile(
              leading: const Icon(
                Icons.assured_workload,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                'Bank to Bank transfer',
                Colors.white,
                16.0,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BankToBankTransfterScreen()),
                );
              },
            ),*/
            /*ListTile(
              leading: const Icon(
                Icons.account_balance,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                'Self transfer',
                Colors.white,
                16.0,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SelfTransferScreen()),
                );
              },
            ),*/

            ListTile(
              leading: const Icon(
                Icons.wallet,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                'Withdraw money',
                Colors.white,
                16.0,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WithdrawScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.score,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_CREDIT_SCORE,
                Colors.white,
                16.0,
              ),
              onTap: () async {
                SharedPreferences prefs2 =
                    await SharedPreferences.getInstance();
                prefs2.setString('key_show_cc_panel', 'yes');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomBar(
                      selectedIndex: 0,
                    ),
                  ),
                );
              },
            ),
            /*ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_SETTINGS,
                Colors.white,
                16.0,
              ),
            ),*/
            ListTile(
              leading: const Icon(
                Icons.file_copy,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_HISTORY,
                Colors.white,
                16.0,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomBar(
                      selectedIndex: 3,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_CHANGE_PASSWORD,
                Colors.white,
                16.0,
              ),
              onTap: () {
                //
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.help,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_HELP,
                Colors.white,
                16.0,
              ),
              onTap: () {
                //
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              title: textFontPOOPINS(
                //
                'Delete account',
                Colors.red,
                16.0,
                fontWeight: FontWeight.w600,
              ),
              onTap: () async {
                //
                showLogout(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: textFontPOOPINS(
                //
                TEXT_MENU_LOGOUT,
                Colors.white,
                16.0,
              ),
              onTap: () async {
                //
                SharedPreferences prefs2 =
                    await SharedPreferences.getInstance();
                prefs2.remove('key_show_cc_panel');
                prefs2.remove('Key_save_login_user_id');
                prefs2.remove('Key_save_login_profile_picture');
                //
                signOut(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void showLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Delete account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Your account will be deleted account permanently.',
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    SharedPreferences prefs2 =
                        await SharedPreferences.getInstance();
                    prefs2.remove('key_show_cc_panel');
                    prefs2.remove('Key_save_login_user_id');
                    prefs2.remove('Key_save_login_profile_picture');
                    //
                    signOut(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                  child: const Text('Delete my account'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
