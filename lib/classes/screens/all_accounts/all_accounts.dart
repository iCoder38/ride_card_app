import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/screens/all_accounts/account_details/account_details.dart';
import 'package:ride_card_app/classes/service/UNIT/create_account/create_account.dart';
import 'package:ride_card_app/classes/service/UNIT/get_customer_accounts_list/get_customer_account_list.dart';
import 'package:uuid/uuid.dart';

class AllAccountsScreen extends StatefulWidget {
  const AllAccountsScreen({super.key});

  @override
  State<AllAccountsScreen> createState() => _AllAccountsScreenState();
}

class _AllAccountsScreenState extends State<AllAccountsScreen> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var customerID = '';
  List<dynamic>? accountDetails;
  var screenLoader = true;
  bool floatingVisibility = false;
  bool? accountCreated;
  //
  @override
  void initState() {
    customerID = '1992974';
    fetchAccountDetails();
    super.initState();
  }

  Future<void> fetchAccountDetails() async {
    accountDetails = await GetAllUnitAccountsService
        .getParticularAccountDetailsViaCustomerId(customerID);

    setState(() {
      screenLoader = false;
      floatingVisibility = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Visibility(
        visible: floatingVisibility,
        child: FloatingActionButton(
          onPressed: () {
            //
            areYourSureCreateAccountPopup(
              context,
            );
          },
          tooltip: 'Add account',
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

  void areYourSureCreateAccountPopup(
    BuildContext context,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: textFontPOOPINS(
                      //
                      'Are you sure you want to create an account ?',
                      Colors.black,
                      18.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: Center(
                          child: textFontPOOPINS(
                            'dismiss',
                            Colors.grey,
                            12.0,
                          ),
                        ),
                      ),
                    ),
                    //
                    const SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        //
                        Navigator.pop(context);
                        //
                        _createAccount();
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: Center(
                          child: textFontPOOPINS(
                            'Create',
                            Colors.white,
                            14.0,
                          ),
                        ),
                      ),
                    ),
                    //
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _createAccount() async {
    bool result = await CreateAccountService.createAccount(customerID);
    setState(() {
      accountCreated = result;
    });

    // Print the result to check it
    if (result) {
      debugPrint('Account created successfully.');
      fetchAccountDetails();
    } else {
      debugPrint('Failed to create account.');
    }
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
      child: accountDetails == null
          ? const SizedBox()
          : accountDetails!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 16.0,
                                ),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: hexToColor(appORANGEcolorHexCode),
                                  borderRadius: BorderRadius.circular(
                                    20.0,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: textFontPOOPINS(
                                'No account added yet. Click plus to add.',
                                Colors.white,
                                14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _UIKitAccountsAfterBG(context),
                ),
    );
  }

  Widget _UIKitAccountsAfterBG(BuildContext context) {
    return screenLoader == true
        ? const SizedBox()
        : Column(
            children: [
              const SizedBox(
                height: 80.0,
              ),
              customNavigationBar(
                //
                context,
                TEXT_NAVIGATION_TITLE_ACCOUNTS,
              ),
              for (int i = 0; i < accountDetails!.length; i++) ...[
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
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
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                        ),
                        child: svgImage(
                          'bank',
                          14.0,
                          14.0,
                        ),
                      ),
                      title: textFontPOOPINS(
                        //
                        accountDetails![i]['attributes']['accountNumber'],
                        Colors.black,
                        16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      subtitle: textFontPOOPINS(
                        //
                        accountDetails![i]['type'],
                        Colors.grey,
                        10.0,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (accountDetails![i]['attributes']['status'] ==
                              'Open') ...[
                            textFontORBITRON(
                              accountDetails![i]['attributes']['status'],
                              Colors.green,
                              10.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ] else if (accountDetails![i]['attributes']
                                  ['status'] ==
                              'Frozen') ...[
                            textFontORBITRON(
                              accountDetails![i]['attributes']['status'],
                              Colors.orange,
                              10.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ] else if (accountDetails![i]['attributes']
                                  ['status'] ==
                              'Closed') ...[
                            textFontORBITRON(
                              accountDetails![i]['attributes']['status'],
                              Colors.redAccent,
                              10.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ]
                        ],
                      ),
                      onTap: () {
                        //
                        pushToAccountDetails(context, accountDetails![i]);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ]
            ],
          );
    //
  }

  Future<void> pushToAccountDetails(BuildContext context, data) async {
    //
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountDetailsScreen(
            accountData: data,
          ),
        ));

    if (!mounted) return;
    //
    if (result == 'reload_screen') {
      if (kDebugMode) {
        print(result);
      }
      fetchAccountDetails();
      // funcGetLocalDBdata();
    }
  }
}
