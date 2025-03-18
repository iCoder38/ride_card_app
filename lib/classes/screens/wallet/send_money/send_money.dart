import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/search_user/search_user.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/send_money_portal/send_money_portal.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/service/service.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key, required this.menuBar});

  final String menuBar;

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  var arrAllUser = [];
  bool resultLoader = true;
  //
  @override
  void initState() {
    //
    _allRecentTransaction(context);
    super.initState();
  }

  void _allRecentTransaction(BuildContext context) async {
    List<dynamic> transactions =
        await TransactionService.recentTransaction(context);
    if (transactions.isNotEmpty) {
      // Success: Handle the transactions list as needed
      if (kDebugMode) {
        print('Success: Transactions fetched successfully');
      }
      arrAllUser = transactions;
      setState(() {
        resultLoader = false;
      });
    } else {
      // Failure: Handle the empty list or error case
      if (kDebugMode) {
        print('Failure: No transactions found or an error occurred');
      }
      setState(() {
        resultLoader = false;
      });
    }
    // Handle the transactions list as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      floatingActionButton: Visibility(
        visible: true,
        child: FloatingActionButton(
          onPressed: () {
            //
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchUserScreen(),
              ),
            );
          },
          tooltip: 'Search user',
          backgroundColor: hexToColor(appORANGEcolorHexCode),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
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
      child: resultLoader == true
          ? customCircularProgressIndicator()
          : SingleChildScrollView(
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
        widget.menuBar == 'yes'
            ? customNavigationBarForMenu(
                TEXT_NAVIGATION_TITLE_SEND_MONEY,
                _scaffoldKey,
              )
            : customNavigationBar(context, TEXT_NAVIGATION_TITLE_SEND_MONEY),

        /*GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const SendMoneyPortalScreen(receiverId: ,)),
                  // );
                },
                child: textFontPOOPINS(
                  'Recents',
                  hexToColor(appREDcolorHexCode),
                  16.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              textFontPOOPINS(
                'Contacts',
                hexToColor(appREDcolorHexCode),
                16.0,
                fontWeight: FontWeight.w800,
              ),*/

        const SizedBox(
          height: 20,
        ),
        textFontPOOPINS(
          'Recent',
          Colors.white,
          18.0,
          fontWeight: FontWeight.w800,
        ),
        const SizedBox(
          height: 20,
        ),
        GridView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: arrAllUser.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: GestureDetector(
                    onTap: () {
                      openSendRequestMoney(context, arrAllUser[index]);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      child: CachedNetworkImage(
                        memCacheHeight: 600,
                        memCacheWidth: 600,
                        imageUrl: arrAllUser[index]['profile_picture'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SizedBox(
                          height: 40,
                          width: 40,
                          child: ShimmerLoader(
                            width: MediaQuery.of(context).size.width,
                          ),
                          // child: CircularProgressIndicator(
                          //   strokeWidth: 1,
                          // ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: textFontPOOPINS(
                      arrAllUser[index]['userName'], Colors.white, 12.0),
                ),
                // SizedBox(height: 8),
                // Text(arrAllUser[index]['userName']!),
              ],
            );
          },
        ),
      ],
    );
  }

  void openSendRequestMoney(
    BuildContext context,
    data,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      //

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendMoneyPortalScreen(
                            data: data,
                            title: '1',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // svgImage('camera', 16.0, 16.0),
                            // const SizedBox(
                            //   width: 8.0,
                            // ),
                            textFontPOOPINS(
                              'Send money',
                              Colors.black,
                              12.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      //
                      Navigator.pop(context);
                      //
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendMoneyPortalScreen(
                            data: data,
                            title: '2',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // svgImage('video', 16.0, 16.0),
                            // const SizedBox(
                            //   width: 8.0,
                            // ),
                            textFontPOOPINS(
                              'Request money',
                              Colors.black,
                              12.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                      child: textFontPOOPINS(
                        'Dismiss',
                        Colors.redAccent,
                        12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
