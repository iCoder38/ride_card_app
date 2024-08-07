import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/screens/all_accounts/card_details/card_details.dart';
import 'package:ride_card_app/classes/screens/all_cards/service/service.dart';
import 'package:ride_card_app/classes/service/UNIT/CUSTOMER/all_customer_cards/all_customer_cards.dart';
import 'package:ride_card_app/classes/service/UNIT/ACCOUNT/close_account/close_account.dart';
import 'package:ride_card_app/classes/service/UNIT/ACCOUNT/freeze_account/freeze_account.dart';
import 'package:ride_card_app/classes/service/UNIT/CARD/issue_card/issue_card.dart';
import 'package:ride_card_app/classes/service/UNIT/ACCOUNT/open_account/open_account.dart';
import 'package:ride_card_app/classes/service/UNIT/ACCOUNT/un_freeze/unfreeze_account.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen(
      {super.key, this.accountData, required this.bankType});

  final accountData;
  final String bankType;

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  //
  final ApiService _apiService = ApiService();
  bool accountLimitsLoader = true;
  bool cardsLoader = true;
  var bankAccountId = '';
  var bankAccountNumber = '';
  var accountBalance = '0';

  bool? cardCreated;
  List<dynamic>? allCards;
  //
  @override
  void initState() {
    if (kDebugMode) {
      print('======== BANK ===========');
      print(widget.accountData);
      print(widget.bankType);
    }
    bankAccountId = widget.accountData['id'].toString();
    bankAccountNumber =
        widget.accountData['attributes']['accountNumber'].toString();
    // cents to dollar
    convertCentsToDollar();
    // checkMyAccountDetails();
    fetchAllCardsDetails();
    super.initState();
  }

  // cents to dollar
  convertCentsToDollar() {
    int cents = widget.accountData['attributes']['balance'];
    double dollars = cents / 100;
    accountBalance = dollars.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,

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
        child: _UIKitAccountDetailsAfterBG(context),
      ),
    );
  }

  Widget _UIKitAccountDetailsAfterBG(context) {
    return Column(
      children: [
        const SizedBox(
          height: 80,
        ),
        customNavigationBar(context, TEXT_NAVIGATION_TITLE_ACCOUNTS_DETAILS),
        const SizedBox(
          height: 40.0,
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
                widget.accountData['attributes']['accountNumber'],
                Colors.black,
                16.0,
                fontWeight: FontWeight.w600,
              ),
              subtitle: textFontPOOPINS(
                //
                widget.accountData['type'],
                Colors.grey,
                10.0,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.accountData['attributes']['status'] == 'Open') ...[
                    textFontORBITRON(
                      widget.accountData['attributes']['status'],
                      Colors.green,
                      10.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ] else if (widget.accountData['attributes']['status'] ==
                      'Frozen') ...[
                    textFontORBITRON(
                      widget.accountData['attributes']['status'],
                      Colors.orange,
                      10.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ] else if (widget.accountData['attributes']['status'] ==
                      'Closed') ...[
                    textFontORBITRON(
                      widget.accountData['attributes']['status'],
                      Colors.redAccent,
                      10.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ]
                ],
              ),
              onTap: () {
                //
                // pushToAccountDetails(context, accountDetails![i]);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
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
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                child: svgImage(
                  'account_balance',
                  14.0,
                  14.0,
                ),
              ),
              title: textFontPOOPINS(
                //
                'Balance',
                Colors.black,
                24.0,
                fontWeight: FontWeight.w600,
              ),
              subtitle: textFontPOOPINS(
                //
                DOLLAR_SIGN + accountBalance,
                const Color.fromARGB(255, 86, 85, 85),
                14.0,
              ),
              onTap: () {
                //
                // pushToAccountDetails(context, accountDetails![i]);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        if (widget.accountData['attributes']['status'] == 'Open') ...[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showBottomSheet(context);
                    },
                    child: Container(
                      height: 40.0,
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                      ),
                      child: Center(
                        child: textFontPOOPINS(
                          //
                          'Freeze my account',
                          Colors.orange,
                          12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      //
                      areYourSurecloseAccountPopup(context);
                    },
                    child: Container(
                      height: 40.0,
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                      ),
                      child: Center(
                        child: textFontPOOPINS(
                          //
                          'Close my account',
                          Colors.redAccent,
                          12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else if (widget.accountData['attributes']['status'] == 'Frozen') ...[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      areYourSureUnfreezeAccountPopup(context);
                    },
                    child: Container(
                      height: 40.0,
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                      ),
                      child: Center(
                        child: textFontPOOPINS(
                          //
                          'Unfreeze my account',
                          Colors.orange,
                          12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Container(
                    height: 40.0,
                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    child: Center(
                      child: textFontPOOPINS(
                        //
                        'Close my account',
                        Colors.black,
                        12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else if (widget.accountData['attributes']['status'] == 'Closed') ...[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.0,
                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    child: Center(
                      child: textFontPOOPINS(
                        //
                        'Freeze my account',
                        Colors.black,
                        12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      areYourSureOpenAccountPopup(context);
                    },
                    child: Container(
                      height: 40.0,
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                      ),
                      child: Center(
                        child: textFontPOOPINS(
                          //
                          'Your account is closed',
                          Colors.red,
                          12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(
          height: 30.0,
        ),
        const Divider(
          thickness: 0.4,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 10.0,
          ),
          child: Row(
            children: [
              textFontPOOPINS(
                'Cards',
                hexToColor(appORANGEcolorHexCode),
                26.0,
                fontWeight: FontWeight.w600,
              ),
              IconButton(
                onPressed: () {
                  //
                  if (widget.accountData['attributes']['status'] == 'Open') {
                    addCardPopUp(context, 'message', 'content');
                  } else {
                    customToast(
                      'Your account is not in Open status',
                      Colors.redAccent,
                      ToastGravity.BOTTOM,
                    );
                  }
                },
                icon: Icon(
                  Icons.add_circle_outline_sharp,
                  color: hexToColor(appORANGEcolorHexCode),
                ),
              ),
            ],
          ),
        ),
        cardsLoader == true
            ? textFontPOOPINS(
                'fetching...',
                Colors.white,
                12.0,
              )
            : allCards!.isEmpty
                ? Column(
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      textFontPOOPINS(
                        'No card found. Click plus button to generate your card',
                        Colors.white,
                        12.0,
                      ),
                    ],
                  )
                : _listOfAllIssuedCardsUIKit(context),
      ],
    );
  }

  Widget _listOfAllIssuedCardsUIKit(context) {
    return Column(
      children: [
        for (int i = 0; i < allCards!.reversed.toList().length; i++) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 10.0,
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
                    'card',
                    14.0,
                    14.0,
                  ),
                ),
                title: textFontPOOPINS(
                  //
                  '**** **** **** ${allCards!.reversed.toList()[i]['attributes']['last4Digits'].toString()}',
                  Colors.black,
                  16.0,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: textFontPOOPINS(
                  //
                  'Exp. date: ${allCards!.reversed.toList()[i]['attributes']['expirationDate']}',
                  Colors.grey,
                  10.0,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.chevron_right_outlined,
                    ),
                    if (allCards!.reversed
                            .toList()[i]['attributes']['status']
                            .toString() ==
                        'Active') ...[
                      textFontPOOPINS(
                        //
                        allCards!.reversed
                            .toList()[i]['attributes']['status']
                            .toString(),
                        Colors.green,
                        10.0,
                        fontWeight: FontWeight.w700,
                      )
                    ] else if (allCards!.reversed
                            .toList()[i]['attributes']['status']
                            .toString() ==
                        'Frozen') ...[
                      textFontPOOPINS(
                        //
                        allCards!.reversed
                            .toList()[i]['attributes']['status']
                            .toString(),
                        Colors.orange,
                        10.0,
                        fontWeight: FontWeight.w700,
                      )
                    ] else ...[
                      textFontPOOPINS(
                        //
                        'Closed',
                        Colors.redAccent,
                        10.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ]
                  ],
                ),
                onTap: () {
                  //
                  pushToCardDetails(context, allCards!.reversed.toList()[i]);
                },
              ),
            ),
          )
        ],
      ],
    );
  }

  Future<void> pushToCardDetails(BuildContext context, data) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardDetailsScreen(
          cardData: data,
        ),
      ),
    );

    if (!mounted) return;
    //
    if (result == 'reload_screen') {
      if (kDebugMode) {
        print(result);
      }
      fetchAllCardsDetails();
    }
  }

  Future<void> freezeMyAccount() async {
    String accountId = widget.accountData['id'];
    String baseUrl = '$SANDBOX_LIVE_URL/accounts/$accountId/freeze';

    if (kDebugMode) {
      print(baseUrl);
    }
    final Uri url = Uri.parse(baseUrl);

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    // Define the request body
    Map<String, dynamic> requestBody = {
      "data": {
        "type": ACCOUNT_FREEZE,
        "attributes": {
          "reason": "Other",
          "reasonText": "Per request from customer"
        },
      }
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print(jsonData);
        }
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print(jsonData);
        }
        // If the server returns an error response, throw an exception
        throw Exception('Failed to GET CUSTOMER TOKEN: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  textFontPOOPINS(
                    'Reason',
                    Colors.black,
                    14.0,
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Reason',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    child: textFontPOOPINS(
                      'Freeze my account',
                      Colors.black,
                      14.0,
                    ),
                    onPressed: () {
                      // Handle the submit action
                      Navigator.pop(context);
                      //freezeMyAccount();
                      _handleFreezeAccount();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    /*Future<void> checkMyAccountDetails() async {
    String accountId = widget.accountData['id'];
    String baseUrl = 'https://api.s.unit.sh/accounts/$accountId/limits';
    final Uri url = Uri.parse(baseUrl);

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);

        // Access account details from the jsonData map
        var account = jsonData['data'];
        if (account == null || account.isEmpty) {
          if (kDebugMode) {
            print('THERE IS NO ACCOUNT DATA AVAILABLE');
          }
        } else {
          if (kDebugMode) {
            debugPrint('===================');
            print('Account details: $account');
            debugPrint('===================');
          }
          setState(() {
            accountLimitsLoader = false;
          });
        }
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print('Error fetching account: $jsonData');
        }
        throw Exception('Failed to fetch account details');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }*/
  }

  void areYourSureOpenAccountPopup(
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
                      'Your account is permanently closed.',
                      Colors.black,
                      18.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                /*Row(
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
                        handleOpenAccount();
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
                            'Open',
                            Colors.white,
                            14.0,
                          ),
                        ),
                      ),
                    ),
                    //
                  ],
                ),*/
              ],
            ),
          ),
        );
      },
    );
  }

  void areYourSurecloseAccountPopup(
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
                      'Are you sure you want to close an account ?',
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
                        _handleCloseAccount();
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
                            'Close',
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

  void areYourSureUnfreezeAccountPopup(
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
                      'Are you sure you want to unfreeze an account ?',
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
                        _handleUnfreezeAccount();
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
                            'Unfreeze',
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

  Future<void> _handleFreezeAccount() async {
    bool success = await FreezeAccountService.freezeMyAccount(bankAccountId);

    if (!mounted) return;

    if (success) {
      // Handle success (e.g., show a success message)
      if (kDebugMode) {
        print('Account freeze successfully');
      }
      customToast(
        'Account freeze successfully',
        Colors.redAccent,
        ToastGravity.BOTTOM,
      );
      Navigator.pop(context, 'reload_screen');
    } else {
      // Handle failure (e.g., show an error message)
      if (kDebugMode) {
        print('Failed to freeze account');
      }
    }
  }

  Future<void> _handleUnfreezeAccount() async {
    String accountId = bankAccountId;
    bool success = await UnfreezeAccountService.unFreezeMyAccount(accountId);

    if (!mounted) return;

    if (success) {
      // Handle success (e.g., show a success message)
      if (kDebugMode) {
        print('Account unfrozen successfully');
      }
      customToast(
        'Account unfreeze successfully',
        Colors.green,
        ToastGravity.BOTTOM,
      );
      Navigator.pop(context, 'reload_screen');
    } else {
      // Handle failure (e.g., show an error message)
      if (kDebugMode) {
        print('Failed to unfreeze account');
      }
    }
  }

  Future<void> _handleCloseAccount() async {
    String accountId = bankAccountId;
    bool success = await CloseAccountService.closeMyAccount(accountId);

    if (!mounted) return;

    if (success) {
      // Handle success (e.g., show a success message)
      if (kDebugMode) {
        print('Account close successfully');
      }
      customToast(
        'Account closed successfully',
        Colors.redAccent,
        ToastGravity.BOTTOM,
      );
      Navigator.pop(context, 'reload_screen');
    } else {
      // Handle failure (e.g., show an error message)
      if (kDebugMode) {
        print('Failed to close account');
      }
    }
  }

  Future<void> handleOpenAccount() async {
    String accountId = bankAccountId;
    bool success = await ReopenAccountService.reopenMyAccount(accountId);

    if (!mounted) return;

    if (success) {
      // Handle success (e.g., show a success message)
      if (kDebugMode) {
        print('Account reopen successfully');
      }
      customToast(
        'Account reopen successfully',
        Colors.greenAccent,
        ToastGravity.BOTTOM,
      );
      Navigator.pop(context, 'reload_screen');
    } else {
      // Handle failure (e.g., show an error message)
      if (kDebugMode) {
        print('Failed to reopen account');
      }
    }
  }

  // ALL ISSUED CARDS
  Future<void> fetchAllCardsDetails() async {
    allCards =
        await GetAllCustomerIssuedCards.getParticularCustomerCardViaCustomerId(
      bankAccountId,
    );
    if (kDebugMode) {
      print('========= ALL CARDS ========');
      print(allCards);
      print('=============================');
    }

    setState(() {
      cardsLoader = false;
    });
  }

  //
  void addCardPopUp(
    BuildContext context,
    String message,
    content,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _issueCard();
                        },
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Center(
                            child: widget.bankType == 'businessCustomer'
                                ? textFontPOOPINS(
                                    //
                                    CARD_BUSINESS_VIRTUAL_DEBIT_CARD_NAME,
                                    Colors.black,
                                    16.0,
                                    fontWeight: FontWeight.w500,
                                  )
                                : textFontPOOPINS(
                                    //
                                    CARD_INDIVIDUAL_VIRTUAL_DEBIT_CARD,
                                    Colors.black,
                                    16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textFontPOOPINS(
                                  'Daily Withdrawal: ',
                                  Colors.grey,
                                  12.0,
                                ),
                                textFontPOOPINS(
                                  DOLLAR_SIGN +
                                      CARD_I_V_D_C_DAILY_WITHDRAWAL.toString(),
                                  Colors.black,
                                  12.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textFontPOOPINS(
                                  'Daily Purchase: ',
                                  Colors.grey,
                                  12.0,
                                ),
                                textFontPOOPINS(
                                  DOLLAR_SIGN +
                                      CARD_I_V_D_C_DAILY_PURCHASE.toString(),
                                  Colors.black,
                                  12.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textFontPOOPINS(
                                  'Montly Withdrawal: ',
                                  Colors.grey,
                                  12.0,
                                ),
                                textFontPOOPINS(
                                  DOLLAR_SIGN +
                                      CARD_I_V_D_C_MONTHLY_WITHDRAWAL
                                          .toString(),
                                  Colors.black,
                                  12.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textFontPOOPINS(
                                  'Monthly Purchase: ',
                                  Colors.grey,
                                  12.0,
                                ),
                                textFontPOOPINS(
                                  DOLLAR_SIGN +
                                      CARD_I_V_D_C_MONTHLY_PURCHASE.toString(),
                                  Colors.black,
                                  12.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      //
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: textFontPOOPINS(
                          //
                          'Dismiss',
                          Colors.red,
                          14.0,
                        ),
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

  // ISSUE CARD FROM UNIT
  void _issueCard() async {
    Navigator.pop(context);

    if (widget.bankType == 'businessCustomer') {
      showLoadingUI(context, 'please wait...');
      await sendRequestToProfileDynamic().then((v) async {
        if (kDebugMode) {
          print(v);
        }

        if (v['data']['fullName'].toString() == '') {
          customToast(
            'something went wrong with your name. Please check your name in edit profile section',
            Colors.redAccent,
            ToastGravity.TOP,
          );
          return;
        } else if (v['data']['lastName'].toString() == '') {
          customToast(
            'something went wrong with your name. Please check your name in edit profile section',
            Colors.redAccent,
            ToastGravity.TOP,
          );
          return;
        } else {
          Map<String, dynamic>? businessResponse =
              await IssueBusinessCardService.issueBusinessCard(
            bankAccountId.toString(),
            v['data']['fullName'].toString(),
            v['data']['lastName'].toString(),
            v['data']['dob'].toString(),
            v['data']['email'].toString(),
            v['data']['contactNumber'].toString(),
            v['data']['address'].toString(),
            v['data']['City'].toString(),
            v['data']['state'].toString(),
            v['data']['zipcode'].toString(),
            v['data']['country'].toString(),
          );
          if (kDebugMode) {
            print('BUSINESS CARD REPONSE');
            print(businessResponse);
          }
          Navigator.pop(context);
          _addCardInEvsServer(
              context,
              businessResponse!['data']['attributes']['last4Digits'].toString(),
              businessResponse['data']['id'].toString(),
              businessResponse['data']['relationships']['account']['data']['id']
                  .toString(),
              businessResponse['data']['attributes']['expirationDate']
                  .toString(),
              businessResponse['data']['relationships']['customer']['data']
                  ['id']);
        }
      });
    } else {
      Map<String, dynamic>? response =
          await IssueCardService.issueCard(bankAccountId);

      if (response != null) {
        if (kDebugMode) {
          debugPrint('Card issued successfully.');
          debugPrint('Card details');
          print('Response: $response');
        }
        // add card
        /*if (kDebugMode) {
        print(
          'LAST 4 DIGITS ==> ${response['data']['attributes']['last4Digits']}',
        );
        print('CARD ID ==> ${response['data']['id']}');
        print(
            'EXP YEAR MONTH ==> ${response['data']['attributes']['expirationDate']}');
        print(
            'CUST ID ==> ${response['data']['relationships']['customer']['data']['id']}');
        print(
            'BANK ID ==> ${response['data']['relationships']['account']['data']['id']}');
      }*/

        // add and save card in evs server
        _addCardInEvsServer(
            context,
            response['data']['attributes']['last4Digits'].toString(),
            response['data']['id'].toString(),
            response['data']['relationships']['account']['data']['id']
                .toString(),
            response['data']['attributes']['expirationDate'].toString(),
            response['data']['relationships']['customer']['data']['id']);
      } else {
        if (kDebugMode) {
          print('Failed to issue card');
        }
      }
    }
  }

  void _addCardInEvsServer(
    context,
    String cardNumber,
    String unitCardId,
    String unitBankId,
    String expYearMonth,
    String customerId,
  ) async {
    debugPrint('API ==> ADD CARD');
    //
    showLoadingUI(context, 'please wait...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    // split year and month
    List<String> parts = expYearMonth.split('-');
    String year = parts[0];
    String month = parts[1];

    if (kDebugMode) {
      print('Year: $year');
      print('Month: $month');
    }

    final parameters = {
      'action': 'cardadd',
      'userId': userId,
      'cardNumber': cardNumber.toString(),
      'nameOnCard': FirebaseAuth.instance.currentUser!.email,
      'Expiry_Month': month,
      'Expiry_Year': year,
      'cardType': 'Debit Card'.toString(),
      // unit
      'card_group': '2',
      'unit_card_id': unitCardId,
      'bank_id': unitBankId,
      'bank_number': bankAccountNumber,
      'relationship_card_type': 'depositAccount',
      'customerID': customerId,
      'status': '1' // 1 == active, 2 = not active
    };
    if (kDebugMode) {
      print(parameters);
    }

    try {
      final response = await _apiService.postRequest(parameters, token);
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];
      if (kDebugMode) {
        print('STATUS ==> $successStatus');
        print(successMessage);
      }

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');
        //
        if (successMessage == NOT_AUTHORIZED) {
          //
          apiServiceGT
              .generateToken(
            userId,
            FirebaseAuth.instance.currentUser!.email,
            roleIs,
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            _addCardInEvsServer(
              context,
              cardNumber,
              unitCardId,
              unitBankId,
              expYearMonth,
              customerId,
            );
          });
        } else {
          if (successStatus.toLowerCase() == 'success') {
            //
            Navigator.pop(context);
            fetchAllCardsDetails();
          }
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
