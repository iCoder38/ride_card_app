import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/stripe/generate_token/generate_token.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/model/model.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/sheet/alreadySavedCardSheet.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/sheet/sheet.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/fee_calculator/fee_calculator.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/get_price.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/model/model.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/model/model.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/save_get_card.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/screens/all_accounts/all_accounts.dart';
import 'package:ride_card_app/classes/screens/all_accounts/card_details/card_details.dart';
import 'package:ride_card_app/classes/screens/all_cards/service/service.dart';
import 'package:ride_card_app/classes/screens/convenience_fee/convenience_fees.dart';
import 'package:ride_card_app/classes/service/UNIT/CUSTOMER/all_customer_cards/all_customer_cards.dart';
import 'package:ride_card_app/classes/service/UNIT/ACCOUNT/close_account/close_account.dart';
import 'package:ride_card_app/classes/service/UNIT/ACCOUNT/freeze_account/freeze_account.dart';
import 'package:ride_card_app/classes/service/UNIT/CARD/issue_card/issue_card.dart';
import 'package:ride_card_app/classes/service/UNIT/ACCOUNT/open_account/open_account.dart';
import 'package:ride_card_app/classes/service/UNIT/ACCOUNT/un_freeze/unfreeze_account.dart';
import 'package:ride_card_app/classes/service/charge_money_from_stripe/charge_money_from_stripe.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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
  final stripeService = ChargeMoneyStripeService();
  final GenerateTokenService _apiServiceGT = GenerateTokenService();
  bool accountLimitsLoader = true;
  bool cardsLoader = true;
  var bankAccountId = '';
  var bankAccountNumber = '';
  var accountBalance = '0';

  bool? cardCreated;
  List<dynamic>? allCards;
  //
  // FEES AND TAXES
  String feesAndTaxesType = '';
  double feesAndTaxesAmount = 0.0;
  double calculatedFeeAmount = 0.0;
  double totalAmountAfterCalculateFee = 0.0;
  bool removePopLoader = false;
  double showConvenienceFeesOnPopup = 0.0;
  var savedCardDetailsInDictionary;
  var strWhatUserSelect = '';
  var userSelectWhichCard = '1';
  var storeStripeCustomerId = '';
  @override
  void initState() {
    // getFeesAndTaxes();
    // _dummyAndCheck();
    dataParseInAccountDetails();
    super.initState();
  }

  dataParseInAccountDetails() {
    // API
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
                // widget.accountData['type'],
                "Routing number: ${widget.accountData['attributes']['routingNumber']}",
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
                      // strWhatUserSelect = 'close_bank_account';
                      // showLoadingUI(context, 'please wait...');
                      // Timer(const Duration(milliseconds: 500), () {
                      //   getFeesAndTaxes('accountClosingFee');
                      // });
                      //
                      pushToConvenienceFeeScreen(
                        context,
                        'Close bank account',
                        'accountClosingFee',
                      );

                      // getFeesAndTaxes(userSelectType)
                      //
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
                      debugPrint('UNFREEZE BANK ACCOUNT');
                      pushToConvenienceFeeScreen(
                        context,
                        'Unfreeze account',
                        'accountUnfreeze', // unfreeze account
                      );
                      // areYourSureUnfreezeAccountPopup(context);
                      /*strWhatUserSelect = 'unfreeze_bank_account';
                      showLoadingUI(context, 'please wait...');
                      Timer(const Duration(milliseconds: 500), () {
                        getFeesAndTaxes('accountUnfreeze');
                      });*/
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
                    if (allCards!.length == 5) {
                      customToast(
                        'You can not create more than 5 cards.',
                        Colors.redAccent,
                        ToastGravity.BOTTOM,
                      );
                    } else {
                      addCardPopUp(context, 'message', 'content');
                    }
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
    double convenienceFee,
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
                    child: Column(
                      children: [
                        textFontPOOPINS(
                          //
                          'Are you sure you want to close an account ?',
                          Colors.black,
                          18.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: textFontPOOPINS(
                            //
                            '\nConvenience fee: \$$showConvenienceFeesOnPopup',
                            Colors.black,
                            12.0,
                          ),
                        ),
                      ],
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
                        // strWhatUserSelect = 'close_bank_account2';
                        Navigator.pop(context);
                        //
                        debugPrint('=========================');
                        debugPrint("Handle close account fees");
                        debugPrint('=========================');
                        openCardBottomSheet(context);
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

  void openPopupToGenerateCard(
    BuildContext context,
    double convenienceFee,
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
                    child: Column(
                      children: [
                        textFontPOOPINS(
                          //
                          'Create virtual debit card ?',
                          Colors.black,
                          18.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: textFontPOOPINS(
                            //
                            '\nConvenience fee: \$$showConvenienceFeesOnPopup',
                            Colors.black,
                            12.0,
                          ),
                        ),
                      ],
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

                        openCardBottomSheet(context);
                      },
                      child: Container(
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: Center(
                          child: textFontPOOPINS(
                            'Pay & Create',
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
    double convenienceFee,
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
                    child: Column(
                      children: [
                        textFontPOOPINS(
                          //
                          'Are you sure you want to unfreeze an account ?',
                          Colors.black,
                          18.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: textFontPOOPINS(
                            //
                            '\nConvenience fee: \$$showConvenienceFeesOnPopup',
                            Colors.black,
                            12.0,
                          ),
                        ),
                      ],
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
                        // UNIT: Handle unfreeze account
                        openCardBottomSheet(context);
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
      // Navigator.pop(context);
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
      // Navigator.pop(context);
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
                          userSelectWhichCard = '1';
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
                      GestureDetector(
                        onTap: () {
                          userSelectWhichCard = '2';
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
                                    'Physical Debit card',
                                    Colors.black,
                                    16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                          ),
                        ),
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   color: Colors.white,
                      //   child: Center(
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(4.0),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           textFontPOOPINS(
                      //             'Daily Withdrawal: ',
                      //             Colors.grey,
                      //             12.0,
                      //           ),
                      //           textFontPOOPINS(
                      //             DOLLAR_SIGN +
                      //                 CARD_I_V_D_C_DAILY_WITHDRAWAL.toString(),
                      //             Colors.black,
                      //             12.0,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   color: Colors.white,
                      //   child: Center(
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(4.0),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           textFontPOOPINS(
                      //             'Daily Purchase: ',
                      //             Colors.grey,
                      //             12.0,
                      //           ),
                      //           textFontPOOPINS(
                      //             DOLLAR_SIGN +
                      //                 CARD_I_V_D_C_DAILY_PURCHASE.toString(),
                      //             Colors.black,
                      //             12.0,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   color: Colors.white,
                      //   child: Center(
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(4.0),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           textFontPOOPINS(
                      //             'Montly Withdrawal: ',
                      //             Colors.grey,
                      //             12.0,
                      //           ),
                      //           textFontPOOPINS(
                      //             DOLLAR_SIGN +
                      //                 CARD_I_V_D_C_MONTHLY_WITHDRAWAL
                      //                     .toString(),
                      //             Colors.black,
                      //             12.0,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   color: Colors.white,
                      //   child: Center(
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(
                      //         top: 4.0,
                      //         bottom: 10.0,
                      //       ),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           textFontPOOPINS(
                      //             'Monthly Purchase: ',
                      //             Colors.grey,
                      //             12.0,
                      //           ),
                      //           textFontPOOPINS(
                      //             DOLLAR_SIGN +
                      //                 CARD_I_V_D_C_MONTHLY_PURCHASE.toString(),
                      //             Colors.black,
                      //             12.0,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
      debugPrint('Individual Customer: ISSUE VIRTUAL DEBIT CARD');

      if (userSelectWhichCard == '1') {
        if (allCards!.isEmpty) {
          if (userSelectWhichCard == '1') {
            logger.d('Create virtual debit card');

            _openBottomSheet();
          } else {
            logger.d('Create physical debit card');
            // debugPrint('fee deduct for physical');

            //issueMyPhysicalDebitCard();
          }
        } else {
          pushToConvenienceFeeScreen(
            context,
            'Virtual debit card',
            'generateDebitCard',
          );
        }
      } else {
        pushToConvenienceFeeScreen(
          context,
          'Physical debit card',
          'generateDebitCard',
        );
      }

      /*strWhatUserSelect = 'close_ind_virtual_card';
      showLoadingUI(context, 'please wait...');
      Timer(const Duration(milliseconds: 500), () {
        getFeesAndTaxes('generateDebitCard');
      });*/
    }
  }

  void _openBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: BottomSheetForm());
      },
    );

    if (result != null) {
      // Print or use the result values here
      if (kDebugMode) {
        print("Account Number: ${result['accountNumber']}");
        print("Exp Date: ${result['expDate']}");
        print("Exp Year: ${result['expYear']}");
        print("CVV: ${result['cvv']}");
      }
      checkUserData(result);
    }
  }

  Future<void> checkUserData(result) async {
    showLoadingUI(context, 'please wait...');
    await sendRequestToProfileDynamic().then((v) async {
      if (kDebugMode) {
        //  print(v);
      }
      if (STRIPE_STATUS == 'T') {
        storeStripeCustomerId = v['data']['stripe_customer_id_Test'];
      } else {
        storeStripeCustomerId = v['data']['stripe_customer_id_Live'];
      }
      // logger.d(v);
      logger.d(storeStripeCustomerId);

      final newStripeToken = await createStripeToken(
          cardNumber: result['accountNumber'].toString(),
          expMonth: result['expDate'].toString(),
          expYear: result['expYear'].toString(),
          cvc: result['cvv'].toString());

      logger.d(newStripeToken);
      //

      if (storeStripeCustomerId != '') {
        createStripeCustomerAccount(storeStripeCustomerId);
      } else {
        _registerCustomerInStripe(newStripeToken);
      }
    });
  }

  void _registerCustomerInStripe(stripeToken) async {
    debugPrint('API ==> REGISTER CUSTOMER IN STRIPE');
    //
    // showLoadingUI(context, 'please wait...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();

    final parameters = {
      'action': 'customer',
      'userId': userId,
      'name': loginUserName(),
      'email': loginUserEmail(),
      'tokenID': stripeToken.toString()
    };
    if (kDebugMode) {
      print(parameters);
    }

    try {
      final response = await _apiService.stripePostRequest(parameters, token);
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];
      String customerIdIs = jsonResponse['customer_id'];

      if (kDebugMode) {
        print('STATUS ==> $successStatus');
        print(successMessage);
      }

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');
        //
        if (successMessage == NOT_AUTHORIZED) {
          //
          _apiServiceGT
              .generateToken(
            userId,
            loginUserEmail(),
            roleIs,
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            _registerCustomerInStripe(token);
          });
        } else {
          if (successStatus.toLowerCase() == 'success') {
            //
            // Navigator.pop(context);
            logger.d(customerIdIs);
            logger.d('CUSTOMER IN STRIPE CREATED SUCCESSFULLY');
            editAfterCreateStripeCustomer(context, customerIdIs);
            // editAfterCreateStripeCustomer(context, customerIdIs);
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

  void editAfterCreateStripeCustomer(
    context,
    customerId,
  ) async {
    debugPrint('API ==> EDIT PROFILE');
    // String parseDevice = await deviceIs();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {
      'action': 'editProfile',
      'userId': userId,
      'stripe_customer_id_Test': customerId,
    };
    if (kDebugMode) {
      print(parameters);
    }
    // return;

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
          _apiServiceGT
              .generateToken(
            userId,
            loginUserEmail(),
            roleIs.toString(),
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            editAfterCreateStripeCustomer(context, customerId);
          });
        } else {
          //
          createStripeCustomerAccount(customerId);
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  ///
  // dummy
  void createStripeCustomerAccount(customerId) async {
    debugPrint('API ==> Stripe subscription');
    //
    // showLoadingUI(context, 'please wait...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();

    final parameters = {
      'action': 'subscription',
      'userId': userId,
      'customerId': customerId,
      'plan_type': 'Card'
    };
    if (kDebugMode) {
      print(parameters);
    }

    try {
      final response = await _apiService.stripeCreateRequest(parameters, token);
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
          _apiServiceGT
              .generateToken(
            userId,
            loginUserEmail(),
            roleIs,
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
          });
        } else {
          if (successStatus.toLowerCase() == 'success') {
            //
            // Navigator.pop(context);
            logger.d('SUCCESS: SUBSCRIPTION');
            Navigator.pop(context);
            createVirtualDebitCard();
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

  createVirtualDebitCard() async {
    Map<String, dynamic>? response =
        await IssueCardService.issueCard(bankAccountId);

    if (response != null) {
      if (kDebugMode) {
        debugPrint('Card issued successfully.');
        debugPrint('Card details');
        print('Response: $response');
      }
      // Navigator.pop(context);
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
          response['data']['relationships']['account']['data']['id'].toString(),
          response['data']['attributes']['expirationDate'].toString(),
          response['data']['relationships']['customer']['data']['id']);
    } else {
      if (kDebugMode) {
        print('Failed to issue card');
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

  // TAXES AND FEES
  void getFeesAndTaxes(userSelectType) async {
    ApiServiceToGetFeesAndTaxes apiService = ApiServiceToGetFeesAndTaxes();

    List<FeeData>? feeList = await apiService.fetchFeesAndTaxes();

    if (feeList != null) {
      for (var fee in feeList) {
        if (kDebugMode) {
          print(
            'ID: ${fee.id}, Name: ${fee.name}, Type: ${fee.type}, Amount: ${fee.amount}',
          );
        }
        if (fee.name == userSelectType) {
          // account closing
          debugPrint('===========================');
          debugPrint('====> $userSelectType <====');
          debugPrint('===========================');
          if (fee.type == TAX_TYPE_PERCENTAGE) {
            feesAndTaxesType = fee.type.toString();
            feesAndTaxesAmount = double.parse(fee.amount.toString());
            showConvenienceFeesOnPopup = (feesAndTaxesAmount * 10) / 100;
            totalAmountAfterCalculateFee = (feesAndTaxesAmount * 10) / 100;
          } else {
            debugPrint(fee.type);
            feesAndTaxesType = fee.type.toString();
            feesAndTaxesAmount = double.parse(fee.amount.toString());
            showConvenienceFeesOnPopup = feesAndTaxesAmount;
            // (feesAndTaxesAmount * 10) / 100;
            totalAmountAfterCalculateFee = feesAndTaxesAmount;
            // (feesAndTaxesAmount * 10) / 100;
            // return;
          }
        }
      }
      if (feesAndTaxesType == TAX_TYPE_PERCENTAGE) {
        String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
        showConvenienceFeesOnPopup = double.parse(formattedValue.toString());
        // if (kDebugMode) {
        //   print(showConvenienceFeesOnPopup);
        // }
        // FEES CALCULATOR
        calculateFeesAndReturnValue();
      } else {
        if (kDebugMode) {
          // print(showConvenienceFeesOnPopup);
          // String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
          // print(formattedValue);
        }
        String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
        showConvenienceFeesOnPopup = double.parse(formattedValue.toString());
        // FEES CALCULATOR
        calculateFeesAndReturnValue();
      }
    } else {
      if (kDebugMode) {
        print('Failed to retrieve fee data.');
      }
    }
  }

  calculateFeesAndReturnValue() {
    double calculatedFee = FeeCalculator.calculateFee(
      feesAndTaxesType,
      feesAndTaxesAmount,
    );
    totalAmountAfterCalculateFee = calculatedFee;
    if (kDebugMode) {
      print(totalAmountAfterCalculateFee);
    }
    //
    Navigator.pop(context);
    if (strWhatUserSelect == 'close_bank_account') {
      areYourSurecloseAccountPopup(context, showConvenienceFeesOnPopup);
    } else if (strWhatUserSelect == 'unfreeze_bank_account') {
      areYourSureUnfreezeAccountPopup(context, showConvenienceFeesOnPopup);
    } else {
      debugPrint('OPEN POPUP TO GENERATE CARD');
      openPopupToGenerateCard(context, showConvenienceFeesOnPopup);
    }
  }

  // OPEN BOTTOM SHEET WITH ENTER CARD DETAILS
  void openCardBottomSheet(BuildContext context) async {
    final result = await showCardBottomSheet(context);

    if (result == null) return;

    if (result['topButtonClicked'] == true) {
      await handleTopButtonClicked(context);
    } else {
      final cardDetails = result['cardDetails'] as CardDetailsForTaxAndFees;
      final saveCard = result['saveCard'] as bool;
      await processCardPayment(context, cardDetails, saveCard);
    }
  }

  // USER CLICK SAVED CARD BUTTON
  Future<void> handleTopButtonClicked(BuildContext context) async {
    final savedCardDetails = await getUserSavedCardDetails(loginUserId());

    if (savedCardDetails != false) {
      savedCardDetailsInDictionary = savedCardDetails;
      Timer(const Duration(milliseconds: 300), handleTimeout);
    } else {
      debugPrint('No card is saved in Firebase');
    }
  }

  // ALL ENTERED OR SAVED CARD DETAILS RETURN
  Future<void> processCardPayment(BuildContext context,
      CardDetailsForTaxAndFees cardDetails, bool saveCard) async {
    if (kDebugMode) {
      print('Cardholder Name: ${cardDetails.cardholderName}');
      print('Card Number: ${cardDetails.cardNumber}');
      print('Exp. Month: ${cardDetails.expMonth}');
      print('Exp. Year: ${cardDetails.expYear}');
      print('CVV: ${cardDetails.cvv}');
      print('Save Card: $saveCard');
    }

    processPayment(
      context,
      cardDetails.cardholderName,
      cardDetails.cardNumber,
      cardDetails.expMonth,
      cardDetails.expYear,
      cardDetails.cvv,
      totalAmountAfterCalculateFee,
      saveCard,
    );
  }

  // IF USER CLICK ON SAVED CARD SO THAT CALLED
  void handleTimeout() async {
    final cardDetails = SavedCardDetails(
      cardNumber: savedCardDetailsInDictionary['cardNumber'],
      cardholderName: savedCardDetailsInDictionary['cardHolderName'],
      expMonth: savedCardDetailsInDictionary['cardExpMonth'],
      expYear: savedCardDetailsInDictionary['cardExpYear'],
      cvv: '', // CVV will be input by the user
    );

    final updatedCardDetails = await showCardDetailsDialog(
      context,
      cardDetails,
    );

    if (updatedCardDetails != null) {
      if (kDebugMode) {
        print('Cardholder Name: ${updatedCardDetails.cardholderName}');
        print('Card Number: ${updatedCardDetails.cardNumber}');
        print('Exp. Month: ${updatedCardDetails.expMonth}');
        print('Exp. Year: ${updatedCardDetails.expYear}');
        print('CVV: ${updatedCardDetails.cvv}');
        // print('SAVED: ${updatedCardDetails.saveCard}');
      }

      processPayment(
        context,
        updatedCardDetails.cardholderName,
        updatedCardDetails.cardNumber,
        updatedCardDetails.expMonth,
        updatedCardDetails.expYear,
        updatedCardDetails.cvv,
        totalAmountAfterCalculateFee,
        true,
        // convertDollarToCentsInDouble(totalAmountAfterCalculateFee),
      );
    }
  }

  void processPayment(
    BuildContext context,
    name,
    number,
    month,
    year,
    cvv,
    amount,
    cardSavedStatus,
  ) async {
    debugPrint('STRIPE: Create token hit');

    final token = await createStripeToken(
        cardNumber: number.toString(),
        expMonth: month.toString(),
        expYear: year.toString(),
        cvc: cvv.toString());

    // Use the token for further processing, such as making a payment
    if (kDebugMode) {
      print('Received token: $token');
      print('Stripe amount to send: $amount');
      print('Stripe amount to send: $cardSavedStatus');
    }

    if (cardSavedStatus == true) {
      final card = CardModel(
        userId: loginUserId(),
        cardHolderName: loginUserName(),
        cardNumber: number.toString(),
        cardExpMonth: month.toString(),
        cardExpYear: year.toString(),
        cardId: const Uuid().v4(),
        cardStatus: true,
      );

      final success = await SavedCardService.saveUserCardInRealDB(card);
      if (success) {
        debugPrint('Firebase: Card saved successfully');
        // API: Charge amount
      } else {
        debugPrint('Failed to save card');
      }
    } else {}
    chargeMoneyFromStripeAndAddToEvsServer(
      amount,
      token,
      cardSavedStatus,
    );
  }

  chargeMoneyFromStripeAndAddToEvsServer(
    amount,
    token,
    getCardSavedStatus,
  ) async {
    debugPrint('API: Charge amount: Send stripe data to server.');
    showLoadingUI(context, 'Please wait...');
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    //
    if (kDebugMode) {
      print('===================================');
      print('CONVENIENCE FEES IS: ====> $amount');
      print('===================================');
    }
    final response = await stripeService.chargeMoneyFromStripeAfterGettingToken(
      amount: amount,
      stripeCardToken: token,
      type: feesAndTaxesType,
    );

    if (kDebugMode) {
      print(response!.message);
    }
    if (response != null) {
      if (response.status == 'Fail') {
        debugPrint('API: FAILS.');
        Navigator.pop(context);
        customToast(
          response.message,
          Colors.redAccent,
          ToastGravity.BOTTOM,
        );
      } else if (response.status == 'NOT_AUTHORIZED') {
        debugPrint('CHARGE AMOUNT API IS NOT AUTHORIZE. PLEASE AUTHORIZE');
        _apiServiceGT
            .generateToken(
          userId,
          loginUserEmail(),
          roleIs,
        )
            .then((v) {
          if (kDebugMode) {
            print('TOKEN ==> $v');
          }
          // again click
          chargeMoneyFromStripeAndAddToEvsServer(
            amount,
            token,
            getCardSavedStatus,
          );
        });
        return;
      } else {
        debugPrint(
          'Success: Payment deducted from stripe. Now create UNIT bank account',
        );
        //

        // NOE CREATE A UNIT BANK ACCOUNT
        debugPrint('======================================');
        debugPrint('DO MAIN FUNCTION HERE AFTER EVERYTHING');
        debugPrint('======================================');
        if (strWhatUserSelect == 'close_bank_account') {
          // close bank account
          _handleCloseAccount();
        } else if (strWhatUserSelect == 'unfreeze_bank_account') {
          // unfreeze bank account
          _handleUnfreezeAccount();
        } else if (strWhatUserSelect == 'close_ind_virtual_card') {
          // unfreeze bank account
          // createVirtualDebitCard();
        }
      }
    } else {
      Navigator.pop(context);
    }
  }

  void issueMyPhysicalDebitCard() async {
    showLoadingUI(context, 'please wait...');
    await sendRequestToProfileDynamic().then((v) async {
      if (kDebugMode) {
        print(v);
      }
      Map<String, dynamic>? businessResponse =
          await IssueCardService.issueCardForIndividualDebitCard(
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
        print('Card: Individual physical card');
        print(businessResponse);
      }
      Navigator.pop(context);
      _addCardInEvsServer(
          context,
          businessResponse!['data']['attributes']['last4Digits'].toString(),
          businessResponse['data']['id'].toString(),
          businessResponse['data']['relationships']['account']['data']['id']
              .toString(),
          businessResponse['data']['attributes']['expirationDate'].toString(),
          businessResponse['data']['relationships']['customer']['data']['id']);
    });
  }

  Future<void> pushToConvenienceFeeScreen(
    BuildContext context,
    String title,
    String feeType,
  ) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConvenienceFeesChargesScreen(
          title: title, //'Close my account',
          feeType: feeType, // 'accountClosingFee',
        ),
      ),
    );

    if (!mounted) return;
    //
    if (result == REFRESH_CONVENIENCE_FEES) {
      if (kDebugMode) {
        print(result);
        print(feeType);
        print(allCards!.length);
      }
      if (feeType == 'accountClosingFee') {
        _handleCloseAccount();
      } else if (feeType == 'generateDebitCard') {
        if (userSelectWhichCard == '1') {
          createVirtualDebitCard();
        } else {
          debugPrint('fee deduct for physical');

          issueMyPhysicalDebitCard();
        }
      } else {
        _handleUnfreezeAccount();
      }
    }
  }
}
