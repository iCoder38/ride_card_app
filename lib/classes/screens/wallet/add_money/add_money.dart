import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/all_cards/service/service.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/send_money.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  //
  @override
  void initState() {
    //
    fetchProfileData('0');
    super.initState();
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
                          title: textFontPOOPINS(
                            // sv
                            cards[i]['cardNumber'],
                            Colors.black,
                            18.0,
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: textFontPOOPINS(
                            // sv
                            cards[i]['Expiry_Month'] +
                                '/' +
                                cards[i]['Expiry_Year'],
                            Colors.black,
                            12.0,
                          ),
                          onTap: () {
                            if (strUserSelectAmount == '0') {
                              //
                              customToast(
                                'Please select amount first',
                                Colors.orange,
                                ToastGravity.BOTTOM,
                              );
                            } else if (strUserSelectAmount == '3') {
                              showCustomPopupForCustom(
                                context,
                                cards[i]['cardNumber'],
                              );
                            } else if (strUserSelectAmount == '2') {
                              showCustomPopup(
                                context,
                                '500',
                                cards[i]['cardNumber'],
                              );
                            } else {
                              showCustomPopup(
                                context,
                                '100',
                                cards[i]['cardNumber'],
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

  //
  void showCustomPopup(BuildContext context, String amount, String cardNumber) {
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
                'Card number: $cardNumber',
                Colors.black,
                12.0,
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: firstController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter price'),
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

                  // evs api: add money
                  _addMoney(context, firstValue, 'dummy_1');
                },
                child: Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  //
  void showCustomPopupForCustom(BuildContext context, String cardNumber) {
    // Create controllers for text fields
    TextEditingController firstController = TextEditingController();
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
                'Card number: $cardNumber',
                Colors.black,
                12.0,
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: firstController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter price'),
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

                  // evs api: add money
                  _addMoney(context, firstValue, 'dummy_1');
                },
                child: Text('Submit'),
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

  // API
  void _addMoney(context, String amount, String transactionId) async {
    debugPrint('API ==> ADD MONEY');
    showLoadingUI(context, 'adding...');
    // customToast('adding please wait...', Colors.green, ToastGravity.BOTTOM);

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
            // again click api
            _addMoney(context, amount, transactionId);
          });
          //
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
}
