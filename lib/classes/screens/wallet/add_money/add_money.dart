import 'dart:convert';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neopop/neopop.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/screens/all_cards/add_card/add_card.dart';
import 'package:ride_card_app/classes/screens/all_cards/service/service.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  //
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();

  bool screenLoader = true;
  var myFullData;
  var myCurrentBalance;
  final apiService = ApiServiceForListOfAllCards();
  List<dynamic> cards = [];
  var strUserSelectAmount = '0';
  var strUserSelectCardType = '0';
  var strUserSelectCardNumber = '';
  var strUserSelectedCardLast4Digits = '';
  var strUserSelectedCardBankId = '';
  //
  @override
  void initState() {
    // print(loginUserType().toString());
    fetchProfileData('0');
    super.initState();
  }

  createPaymentToken() async {
    final paymentIntent = await Stripe.instance.confirmPlatformPayPaymentIntent(
        clientSecret: 'clientSecret',
        confirmParams: PlatformPayConfirmParams.googlePay(
          googlePay: GooglePayParams(
            testEnv: true,
            merchantName: 'Example Merchant Name',
            merchantCountryCode: 'Es',
            currencyCode: 'EUR',
          ),
        ));
    print(paymentIntent);
    // PaymentIntentParams(clientSecret: 'your_client_secret', paymentMethodId: paymentMethod.id),
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: _UIKitAddMoneyAfterBG(context),
      ),
    );
  }

  Widget _UIKitAddMoneyAfterBG(context) {
    return screenLoader == true
        ? const SizedBox()
        : Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              //customNavigationBar(context, TEXT_NAVIGATION_TITLE_ADD_MONEY),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, 'reload_screen');
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
                  const SizedBox(
                    width: 40.0,
                  ),
                  Container(
                    height: 40,
                    color: Colors.transparent,
                    child: Center(
                      child: textFontORBITRON(
                        //
                        TEXT_NAVIGATION_TITLE_ADD_MONEY,
                        Colors.white,
                        18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: textFontPOOPINS(
                                    '\nCurrent balance\n',
                                    Colors.black,
                                    16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: textFontPOOPINS(
                                    // sv
                                    COUNTRY_CURRENCY + myCurrentBalance,
                                    Colors.black,
                                    30.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              debugPrint('object');
                              Navigator.pop(context, 'reload_screen');
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Center(
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: hexToColor(appREDcolorHexCode),
                                  borderRadius: BorderRadius.circular(
                                    16.0,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: textFontPOOPINS(
                  TEXT_SELECT_AMOUNT,
                  hexToColor(appORANGEcolorHexCode),
                  16.0,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: textFontPOOPINS(
                  TEXT_SELECT_AMOUNT_SUB_TITLE,
                  Colors.white,
                  12.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            strUserSelectAmount = '1';
                          });
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: strUserSelectAmount == '1'
                                ? Colors.orangeAccent
                                : Colors.white,
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset(
                                      'assets/images/dollar@2x.png',
                                    ),
                                  ),
                                ),
                                textFontPOOPINS(
                                  '\$100',
                                  Colors.black,
                                  26.0,
                                  fontWeight: FontWeight.w800,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            strUserSelectAmount = '2';
                          });
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: strUserSelectAmount == '2'
                                ? Colors.orangeAccent
                                : Colors.white,
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset(
                                      'assets/images/dollar@2x.png',
                                    ),
                                  ),
                                ),
                                textFontPOOPINS(
                                  '\$500',
                                  Colors.black,
                                  26.0,
                                  fontWeight: FontWeight.w800,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            strUserSelectAmount = '3';
                          });
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: strUserSelectAmount == '3'
                                ? Colors.orangeAccent
                                : Colors.white,
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset(
                                      'assets/images/dollar@2x.png',
                                    ),
                                  ),
                                ),
                                textFontPOOPINS(
                                  'Custom',
                                  Colors.black,
                                  20.0,
                                  fontWeight: FontWeight.w800,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ListTile(
                title: textFontPOOPINS(
                  //
                  TEXT_SELECT_CARD_TITLE,
                  hexToColor(appORANGEcolorHexCode),
                  16.0,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: textFontPOOPINS(
                  //
                  TEXT_SELECT_CARD_SUB_TITLE,
                  Colors.white,
                  12.0,
                  fontWeight: FontWeight.w400,
                ),
                trailing: IconButton(
                  onPressed: () {
                    //
                    pushToAddCardScreen(context);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.amber,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    for (int i = 0; i < cards.length; i++) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: cards[i]['card_group'].toString() == '2'
                              ? textFontPOOPINS(
                                  // sv
                                  // ignore: prefer_interpolation_to_compose_strings
                                  '**** **** ****' + cards[i]['cardNumber'],
                                  Colors.black,
                                  18.0,
                                  fontWeight: FontWeight.w600,
                                )
                              : textFontPOOPINS(
                                  // sv
                                  cards[i]['cardNumber'],
                                  Colors.black,
                                  18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          subtitle: textFontPOOPINS(
                            // sv
                            cards[i]['Expiry_Year'] +
                                '-' +
                                cards[i]['Expiry_Month'],
                            Colors.grey,
                            12.0,
                          ),
                          trailing: cards[i]['card_group'].toString() == '2'
                              ? textFontPOOPINS('RCS', Colors.grey, 8.0)
                              : textFontPOOPINS('External', Colors.grey, 8.0),
                          onTap: () {
                            debugPrint('USER CLICK LIST TILE');
                            debugPrint('CG: ${cards[i]['card_group']}');
                            debugPrint('CN: ${cards[i]['cardNumber']}');
                            debugPrint('CN: ${cards[i]}');
                            strUserSelectedCardLast4Digits =
                                cards[i]['cardNumber'].toString();
                            strUserSelectedCardBankId =
                                cards[i]['bank_id'].toString();
                            //
                            cards[i]['card_group'].toString() == '2'
                                ? strUserSelectCardType = '2' // unit
                                : strUserSelectCardType = '1'; // external
                            debugPrint(strUserSelectCardType.toString());
                            // check
                            if (strUserSelectAmount == '0') {
                              //
                              cards[i]['card_group'].toString() == '2'
                                  ? showBottomSheet(context)
                                  : customToast(
                                      'Please select amount first',
                                      Colors.orange,
                                      ToastGravity.BOTTOM,
                                    );
                            } else if (strUserSelectAmount == '3') {
                              strUserSelectCardNumber =
                                  cards[i]['cardNumber'].toString();
                              cards[i]['card_group'].toString() == '2'
                                  ? showBottomSheet(context)
                                  : showCustomPopupForCustom(
                                      context,
                                      cards[i]['cardNumber'],
                                      cards[i]['Expiry_Month'],
                                      cards[i]['Expiry_Year'],
                                    );
                            } else if (strUserSelectAmount == '2') {
                              strUserSelectCardNumber =
                                  cards[i]['cardNumber'].toString();
                              cards[i]['card_group'].toString() == '2'
                                  ? showBottomSheet(context)
                                  : showCustomPopup(
                                      context,
                                      '500',
                                      cards[i]['cardNumber'],
                                      cards[i]['Expiry_Month'],
                                      cards[i]['Expiry_Year'],
                                    );
                            } else {
                              strUserSelectCardNumber =
                                  cards[i]['cardNumber'].toString();
                              cards[i]['card_group'].toString() == '2'
                                  ? showBottomSheet(context)
                                  : showCustomPopup(
                                      context,
                                      '100',
                                      cards[i]['cardNumber'],
                                      cards[i]['Expiry_Month'],
                                      cards[i]['Expiry_Year'],
                                    );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 6.0),
                    ]
                  ],
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: hexToColor(appREDcolorHexCode),
                    borderRadius: BorderRadius.circular(
                      14.0,
                    ),
                  ),
                  child: Center(
                    child: textFontPOOPINS(
                      //
                      TEXT_PROCCED,
                      Colors.white,
                      18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )*/
            ],
          );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*Padding(
                padding: const EdgeInsets.all(18.0),
                child: NeoPopTiltedButton(
                  isFloating: true,
                  onTapUp: () {
                    if (kDebugMode) {
                      print('CLICKED ==> CVV');
                    }
                  },
                  decoration: NeoPopTiltedButtonDecoration(
                    color: const Color.fromRGBO(255, 235, 52, 1),
                    plunkColor: hexToColor(appORANGEcolorHexCode),
                    shadowColor: const Color.fromRGBO(36, 36, 36, 1),
                    showShimmer: true,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70.0,
                      vertical: 15,
                    ),
                    child: textFontPOOPINS(
                      'Show CVV',
                      Colors.black,
                      14.0,
                    ),
                  ),
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: NeoPopTiltedButton(
                  isFloating: true,
                  onTapUp: () {
                    if (kDebugMode) {
                      print('CLICKED ==> ADD MONEY TO WALLET');
                    }
                    Navigator.pop(context);
                    if (strUserSelectAmount == '0') {
                      customToast(
                        'Please select amount first',
                        Colors.orange,
                        ToastGravity.BOTTOM,
                      );
                    } else {
                      debugPrint('=======================');
                      debugPrint('USER SELECT SOME AMOUNT');
                      debugPrint(strUserSelectAmount);
                      debugPrint('=======================');
                      /*showCustomPopup(
                        context,
                        '500',
                        '1234',
                      );*/
                      if (strUserSelectAmount == '1') {
                        openPopupWithoutCVV(
                          context,
                          '100',
                        );
                      } else if (strUserSelectAmount == '2') {
                        openPopupWithoutCVV(
                          context,
                          '500',
                        );
                      } else {
                        openPopupWithoutCVV(
                          context,
                          '1',
                        );
                      }
                    }
                  },
                  decoration: NeoPopTiltedButtonDecoration(
                    color: const Color.fromRGBO(255, 235, 52, 1),
                    plunkColor: hexToColor(appORANGEcolorHexCode),
                    shadowColor: const Color.fromRGBO(36, 36, 36, 1),
                    showShimmer: true,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70.0,
                      vertical: 15,
                    ),
                    child: textFontPOOPINS(
                      'Add money to wallet',
                      Colors.black,
                      14.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        );
      },
    );
  }

  void fetchCards(status) async {
    debugPrint('FETCH ALL CARDS');
    List<dynamic> fetchedCards = await apiService.listOfAllCards(context);

    setState(() {
      if (status == '1') {
        Navigator.pop(context);
      }
      cards = fetchedCards;
      screenLoader = false;
      strUserSelectAmount = '0';
    });
  }

  // EVS: API => GET USER PROFILE DATA
  Future<void> fetchProfileData(status) async {
    await sendRequestToProfileDynamic().then((v) {
      myFullData = v;

      // debugPrint(myFullData['data']['wallet'].toString());
      // current wallet balance
      if (myFullData['data']['wallet'].toString() == '') {
        myCurrentBalance = '0';
      } else {
        myCurrentBalance = myFullData['data']['wallet'].toString();
      }
      //
      debugPrint('2222');
      fetchCards(status);
    });
    // print(responseBody);
  }

  void openPopupWithoutCVV(
    BuildContext context,
    String amount,
  ) {
    debugPrint('TWO');
    debugPrint(strUserSelectCardType);
    TextEditingController firstController = TextEditingController(text: amount);
    // TextEditingController secondController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textFontPOOPINS(
            'Add money',
            Colors.black,
            16.0,
            fontWeight: FontWeight.w600,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10.0),
              textFontPOOPINS(
                'Card number: $strUserSelectCardNumber',
                Colors.black,
                10.0,
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: firstController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Enter price'),
              ),
              /*const TextField(
                // controller: firstController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'cvv'),
                maxLength: 3,
              ),
              const SizedBox(height: 20),*/
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                  String firstValue = firstController.text;
                  // String secondValue = secondController.text;

                  if (kDebugMode) {
                    print('First value: $firstValue');
                    debugPrint(strUserSelectCardType);
                  }

                  Navigator.pop(context);

                  if (strUserSelectCardType == '2') {
                    // payment unit
                    debugPrint('UNIT PAYMENT');
                    addMoneyViaUnit(firstValue);
                  } else {
                    debugPrint('STRIPE PAYMENT 1');
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  //
  void showCustomPopup(
    BuildContext context,
    String amount,
    String cardNumber,
    String expMonth,
    String expYear,
  ) {
    debugPrint('TWO');
    debugPrint(strUserSelectCardType);
    TextEditingController firstController = TextEditingController(text: amount);
    TextEditingController cvvController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textFontPOOPINS(
            'Add money',
            Colors.black,
            16.0,
            fontWeight: FontWeight.w600,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10.0),
              textFontPOOPINS(
                'Card number: $strUserSelectCardNumber',
                Colors.black,
                10.0,
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: firstController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Enter price'),
              ),
              TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'cvv'),
                maxLength: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                  String firstValue = firstController.text;
                  // String secondValue = secondController.text;

                  if (kDebugMode) {
                    print('First value: $firstValue');
                    debugPrint(strUserSelectCardType);
                  }

                  Navigator.pop(context);

                  if (strUserSelectCardType == '2') {
                    // payment unit
                    debugPrint('UNIT PAYMENT');
                    addMoneyViaUnit(firstValue);
                  } else {
                    debugPrint('STRIPE PAYMENT 2');
                    generateStripeToken(
                      cardNumber: strUserSelectCardNumber,
                      expMonth: expMonth,
                      expYear: expYear,
                      cvv: cvvController.text.toString(),
                      amount: firstController.text.toString(),
                    ); // generateStripeToken
                    // _addMoney(context, firstValue, 'dummy_1');
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  //
  void showCustomPopupForCustom(
    BuildContext context,
    String cardNumber,
    String expMonth,
    String expYear,
  ) {
    debugPrint('ONE');
    // Create controllers for text fields
    TextEditingController firstController = TextEditingController();
    TextEditingController cvvController = TextEditingController();
    // TextEditingController secondController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textFontPOOPINS(
            'Add money 22',
            Colors.black,
            16.0,
            fontWeight: FontWeight.w600,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10.0),
              textFontPOOPINS(
                'Card number: $strUserSelectCardNumber',
                Colors.black,
                12.0,
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: firstController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Enter price'),
              ),
              TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'cvv'),
                maxLength: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                  String firstValue = firstController.text;
                  // String secondValue = secondController.text;

                  if (kDebugMode) {
                    print('First value: $firstValue');
                    // print('Second value: $secondValue');
                  }

                  Navigator.pop(context);

                  if (strUserSelectCardType == '2') {
                    // payment unit
                    logger.d('UNIT PAYMENT');
                  } else {
                    // evs api: add money
                    logger.d('STRIPE PAYMENT 3');
                    generateStripeToken(
                      cardNumber: strUserSelectCardNumber,
                      expMonth: expMonth,
                      expYear: expYear,
                      cvv: cvvController.text.toString(),
                      amount: firstController.text.toString(),
                    );
                    // _addMoney(context, firstValue, 'dummy_1');
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

//
/*
action:addmoney
userId:
amount:
transactionId:
*/

  Future<void> addMoneyViaUnit(
    String amount,
  ) async {
    showLoadingUI(context, 'please wait...');
    final url = Uri.parse('https://api.s.unit.sh/sandbox/purchases');
    final headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };
    final body = jsonEncode({
      "data": {
        "type": "purchaseTransaction",
        "attributes": {
          "amount": int.parse(convertDollarsToCentsAsString(amount)),
          "direction": "Debit",
          "merchantName": "My wallet",
          "merchantType": 1000,
          "merchantLocation": "Cupertino, CA",
          "coordinates": {"longitude": -77.0364, "latitude": 38.8951},
          "last4Digits": strUserSelectedCardLast4Digits.toString(),
          "recurring": false
        },
        "relationships": {
          "account": {
            "data": {
              "type": "depositAccount",
              "id": strUserSelectedCardBankId.toString(),
            }
          }
        }
      }
    });

    if (kDebugMode) {
      print(body);
    }

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('Transaction created successfully');
          print(jsonDecode(response.body));
        }
        String title = getTransactionIdFromResponse(response.body);
        if (kDebugMode) {
          print('Transaction Id: ====> $title');
        }
        Navigator.pop(context);
        _addMoney(context, amount, title.toString());
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print('Bad request');
          print('Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        Navigator.pop(context);
        String title = getTitleFromErrorResponse(response.body);
        customToast(title, Colors.red, ToastGravity.BOTTOM);
      } else {
        if (kDebugMode) {
          print('Failed to create transaction');
          print('Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        Navigator.pop(context);
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      Navigator.pop(context);
    }
  }

  String getTransactionIdFromResponse(String jsonResponse) {
    final decodedResponse = json.decode(jsonResponse);

    if (decodedResponse.containsKey('data') &&
        decodedResponse['data'].containsKey('attributes') &&
        decodedResponse['data'].containsKey('id')) {
      return decodedResponse['data']['id'].toString();
    }

    return 'Amount not found';
  }

  String getTitleFromErrorResponse(String jsonResponse) {
    final decodedResponse = json.decode(jsonResponse);

    if (decodedResponse.containsKey('errors') &&
        decodedResponse['errors'] is List) {
      final errors = decodedResponse['errors'];
      if (errors.isNotEmpty && errors[0].containsKey('title')) {
        return errors[0]['title'];
      }
    }

    return 'Title not found';
  }

  // API
  void _addMoney(context, String amount, String transactionId) async {
    debugPrint('API ==> ADD MONEY');
    showLoadingUI(context, 'adding...');
    // customToast('adding please wait...', Colors.green, ToastGravity.BOTTOM);
    // return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();

    final parameters = {
      'action': 'addmoney',
      'userId': userId,
      'amount': amount,
      'transactionId': transactionId,
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
          setAndCallRole(userId, amount, transactionId);
        } else {
          //
          fetchProfileData('1');
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

  setAndCallRole(userId, amount, transactionId) async {
    var roleIs = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    roleIs = prefs.getString('key_save_user_role').toString();
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
      // again click api
      _addMoney(context, amount, transactionId);
    });
  }

  Future<void> pushToAddCardScreen(BuildContext context) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCardScreen(
          strMenuBack: 'yes',
        ),
      ),
    );

    if (!mounted) return;
    //
    if (result == 'reload_screen') {
      if (kDebugMode) {
        print(result);
      }
      fetchProfileData('0');
    }
  }

  // STRIPE MONEY SYSTEM
  Future<String?> generateStripeToken({
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvv,
    required String amount,
  }) async {
    showLoadingUI(context, 'please wait...');
    CardTokenParams cardParams = CardTokenParams(
      type: TokenType.Card,
      name: FirebaseAuth.instance.currentUser!.displayName,
    );

    await Stripe.instance.dangerouslyUpdateCardDetails(
      CardDetails(
        number: cardNumber.toString(),
        cvc: cvv,
        expirationMonth: int.tryParse(expMonth.toString()),
        expirationYear: int.tryParse(expYear.toString()),
      ),
    );

    if (kDebugMode) {
      print('amount: $amount');
      print('card number: $cardNumber');
      print('cvv: $cvv');
      print('exp month: $expMonth');
      print('exp year: $expYear');
    }

    try {
      TokenData token = await Stripe.instance.createToken(
        CreateTokenParams.card(params: cardParams),
      );
      if (kDebugMode) {
        print("Flutter Stripe token  ${token.toJson()}");
        print(token.id.toString());
      }

      chargeMoneyFromStripe(
        amount,
        token.id.toString(),
      );
      // return token.id;
    } on StripeException catch (e) {
      // Utils.errorSnackBar(e.error.message);
      /*if (kDebugMode) {
        print("Flutter Stripe error ${e.error.message}");
      }*/
      Navigator.pop(context);
      customToast(
        '${e.error.message}',
        Colors.redAccent,
        ToastGravity.BOTTOM,
      );
    }
    return null;
  }

  setAndCallRole2(userId, amount, stripeCardToken) async {
    var roleIs = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    roleIs = prefs.getString('key_save_user_role').toString();
    debugPrint('==============================================');
    debugPrint(roleIs);
    debugPrint('==============================================');
    apiServiceGT
        .generateToken(userId, FirebaseAuth.instance.currentUser!.email, roleIs)
        .then((v) {
      //
      if (kDebugMode) {
        print('TOKEN ==> $v');
      }
      // again click
      chargeMoneyFromStripe(
        amount,
        stripeCardToken,
      );
    });
  }

  void chargeMoneyFromStripe(
    String amount,
    String stripeCardToken,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();

    String url = STRIPE_CHARGE_AMOUNT_URL;

    //
    var doubleParse = double.parse(amount.toString()) * 100;

    // Example parameters
    Map<String, dynamic> body = {
      'action': 'chargeramount',
      'userId': userId.toString(),
      'amount': doubleParse,
      'tokenID': stripeCardToken,
    };
    if (kDebugMode) {
      print(body);
    }

    // Encode your parameters as JSON if needed
    String jsonBody = json.encode(body);

    // Define your headers
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'token': token
    };

    // Make the POST request
    http
        .post(Uri.parse(url), headers: headers, body: jsonBody)
        .then((response) {
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String successStatus = jsonResponse['status'];
        if (successStatus == 'Fail') {
          Navigator.pop(context);
          customToast(
            jsonResponse['status'].toString(),
            Colors.redAccent,
            ToastGravity.BOTTOM,
          );
        } else if (successStatus == NOT_AUTHORIZED) {
          //
          setAndCallRole2(userId, amount, stripeCardToken);
        } else {
          Navigator.pop(context);
          _addMoney(context, amount, 'qwerty 1234');
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}');
        }
        Navigator.pop(context);
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      Navigator.pop(context);
    });
  }

  /*void _add(
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
            'Member',
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
            // fetchAllCardsDetails();
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
  }*/
}
