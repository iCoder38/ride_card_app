import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/wallet/add_money/add_money.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/send_money.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/service/service.dart';
import 'package:ride_card_app/classes/screens/wallet/widgets/widgets.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  //
  bool screenLoader = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  var myFullData;
  var arrAllUser = [];
  bool resultLoader = true;
  //
  @override
  void initState() {
    //
    fetchProfileData();
    super.initState();
  }

  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) {
      myFullData = v;
      if (kDebugMode) {
        print(myFullData);
      }
      //
      _allRecentTransaction(context);

      // parseValue();
    });
    // print(responseBody);
  }

  void _allRecentTransaction(BuildContext context) async {
    List<dynamic> transactions =
        await TransactionService.transacctionHistory(context);
    if (transactions.isNotEmpty) {
      // Success: Handle the transactions list as needed
      if (kDebugMode) {
        print('Success: Transactions fetched successfully');
      }
      arrAllUser = transactions;
      setState(() {
        resultLoader = false;
        screenLoader = false;
      });
    } else {
      // Failure: Handle the empty list or error case
      if (kDebugMode) {
        print('Failure: No transactions found or an error occurred');
      }
    }
    // Handle the transactions list as needed
  }

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
    return screenLoader == true
        ? const SizedBox()
        : Column(
            children: [
              const SizedBox(
                height: 80.0,
              ),
              customNavigationBarForMenu(
                  TEXT_NAVIGATION_TITLE_WALLET, _scaffoldKey),
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
                      widgetWalletUpperDeckContainerLeft(
                          context, myFullData['data']['wallet'].toString()),
                      //widgetWalletUpperDeckContainerRight(context),
                      Expanded(
                        child: Container(
                          height: 120,
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SendMoneyScreen(
                                        menuBar: 'no',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: hexToColor(appORANGEcolorHexCode),
                                    borderRadius: BorderRadius.circular(
                                      14.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: textFontPOOPINS(
                                      'Send',
                                      Colors.white,
                                      16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //
                                  pushToAddMoney(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: hexToColor(appREDcolorHexCode),
                                    borderRadius: BorderRadius.circular(
                                      14.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: textFontPOOPINS(
                                      'Add money',
                                      Colors.white,
                                      16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
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
              for (int i = 0; i < arrAllUser.length; i++) ...[
                if (arrAllUser[i]['type'] == 'Add') ...[
                  ListTile(
                    title: textFontPOOPINS(
                      //
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
                    trailing: Container(
                      width: 120,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.add,
                            size: 16.0,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4.0),
                          textFontORBITRON(
                            //
                            arrAllUser[i]['amount'].toString(),
                            Colors.green,
                            18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (arrAllUser[i]['type'] == 'Sent') ...[
                  ListTile(
                    title: textFontPOOPINS(
                      //
                      'Money sent',
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
                    trailing: Container(
                      width: 120,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.arrow_outward,
                            size: 16.0,
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(width: 4.0),
                          textFontORBITRON(
                            //
                            arrAllUser[i]['amount'].toString(),
                            Colors.orangeAccent,
                            18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  ListTile(
                    title: textFontPOOPINS(
                      //
                      'Money sent',
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
                    trailing: Container(
                      width: 120,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.remove,
                            size: 16.0,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 4.0),
                          textFontORBITRON(
                            //
                            arrAllUser[i]['amount'].toString(),
                            Colors.red,
                            18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
              const Divider(
                thickness: 0.2,
              )
            ],
          );
  }

  //
  Future<void> pushToAddMoney(
    BuildContext context,
  ) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMoneyScreen(),
      ),
    );

    if (!mounted) return;
    //
    if (result == 'reload_screen') {
      if (kDebugMode) {
        print(result);
      }
      //
      fetchProfileData();
      //
    }
  }
}
