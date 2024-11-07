import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/convenience_fee/convenience_fees.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:u_credit_card/u_credit_card.dart';

class AllCardsScreen extends StatefulWidget {
  const AllCardsScreen({super.key});

  @override
  State<AllCardsScreen> createState() => _AllCardsScreenState();
}

class _AllCardsScreenState extends State<AllCardsScreen> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  var arrAllCards = [];
  bool screenLoader = true;
  //
  @override
  void initState() {
    //
    _listOfAllCards(context, '0');
    super.initState();
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
        child: _UIKitManageCardsAfterBG(context),
      ),
    );
  }

  Widget _UIKitManageCardsAfterBG(context) {
    return screenLoader == true
        ? const SizedBox()
        : Column(
            children: [
              const SizedBox(height: 80),
              customNavigationBarForMenu('All Cards', _scaffoldKey),
              const SizedBox(
                height: 40.0,
              ),
              for (int i = 0; i < arrAllCards.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CreditCardUi(
                    width: MediaQuery.of(context).size.width,
                    cardHolderFullName: arrAllCards[i]['nameOnCard'],
                    cardNumber: arrAllCards[i]['cardNumber'],
                    validThru: '',
                    validFrom: arrAllCards[i]['Expiry_Month'] +
                        '/' +
                        arrAllCards[i]['Expiry_Year'],
                    showValidThru: false,
                    topLeftColor: Colors.blue,
                    bottomRightColor: Colors.black,
                    placeNfcIconAtTheEnd: true,
                    enableFlipping: true,
                    cvvNumber: '***',
                    cardType: CardType.debit,
                    cardProviderLogo: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    //

                    /*pushToConvenienceFeeScreen(
                      context,
                      'Delete card',
                      'deleteExternalDebitCard',
                      arrAllCards[i]['cardId'].toString(),
                    );*/
                    _deleteCard(
                      context,
                      arrAllCards[i]['cardId'].toString(),
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                const Divider(
                  thickness: 0.2,
                ),
              ]
            ],
          );
  }

  // API
  void _listOfAllCards(context, status) async {
    debugPrint('API ==> ADD CARD');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {
      'action': 'cardlist',
      'userId': userId,
      'card_group': '1',
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
      String successMessage = '';
      if (jsonResponse['msg'] == null) {
        //
        successMessage = '';
        if (kDebugMode) {
          print('STATUS ==> $successStatus');
          print(successMessage);
        }
      } else {
        successMessage = jsonResponse['msg'];
        if (kDebugMode) {
          print('STATUS ==> $successStatus');
          print(successMessage);
        }
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
            _listOfAllCards(context, status);
          });
        } else {
          //

          //
          arrAllCards = jsonResponse['data'];
          debugPrint('YEAH DONE');
          if (kDebugMode) {
            print(arrAllCards);
          }
          setState(() {
            if (status == '1') {
              Navigator.pop(context);
            }
            screenLoader = false;
          });
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

  //
  // API
  void _deleteCard(context, String cardId) async {
    debugPrint('API ==> DELETE CARD');
    showLoadingUI(context, 'deleting...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {
      'action': 'carddelete',
      'userId': userId,
      'cardId': cardId,
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
      String successMessage = '';
      if (jsonResponse['msg'] == null) {
        //
        successMessage = '';
        if (kDebugMode) {
          print('STATUS ==> $successStatus');
          print(successMessage);
        }
      } else {
        successMessage = jsonResponse['msg'];
        if (kDebugMode) {
          print('STATUS ==> $successStatus');
          print(successMessage);
        }
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
            _deleteCard(context, cardId);
          });
        } else {
          //
          _listOfAllCards(context, '1');
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

  //
  Future<void> pushToConvenienceFeeScreen(
    BuildContext context,
    String title,
    String feeType,
    cardId,
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
      }

      _deleteCard(
        context,
        cardId,
      );
    }
  }
}
