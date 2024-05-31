import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/service/UNIT/get_customer_accounts_list/get_customer_account_list.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
        },
        tooltip: 'Add account',
        backgroundColor: hexToColor(appORANGEcolorHexCode),
        child: const Icon(
          Icons.add,
          color: Colors.white,
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
              ListTile(
                title: textFontPOOPINS(
                  'text',
                  Colors.white,
                  16.0,
                ),
              )
            ],
          );
  }
}
