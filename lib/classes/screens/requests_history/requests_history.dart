//bennet5: 3.5 - 1.6 = 1.9
// daniel: 3.1 + 1.5 = 4.6
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/service/service.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsHistoryScreen extends StatefulWidget {
  const RequestsHistoryScreen({super.key});

  @override
  State<RequestsHistoryScreen> createState() => _RequestsHistoryScreenState();
}

class _RequestsHistoryScreenState extends State<RequestsHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  var arrAllUser = [];
  bool screenLoader = true;
  bool resultLoader = true;
  var strLoginUserId = '0';
  //
  String storeUserWalletAmount = '';

  @override
  void initState() {
    checkUserData();
    super.initState();
  }

  Future<void> checkUserData() async {
    await sendRequestToProfileDynamic().then((v) async {
      // if (kDebugMode) {
      logger.d(v);
      storeUserWalletAmount = v['data']['wallet'].toString();
      logger.d(storeUserWalletAmount);
      // }
      getLoginUserId(context);
    });
  }

  getLoginUserId(context) async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    var userID = prefs2.getString('Key_save_login_user_id').toString();
    strLoginUserId = userID.toString();
    //
    _allRecentTransaction(context);
  }

  void _allRecentTransaction(BuildContext context) async {
    List<dynamic> transactions = await TransactionService.requestsHistoryAPI(
      context,
      'Request',
    );
    if (transactions.isNotEmpty) {
      // Success: Handle the transactions list as needed
      if (kDebugMode) {
        print('Success: REQUESTS Transactions fetched successfully');
      }
      arrAllUser = transactions;
      setState(() {
        resultLoader = false;
        screenLoader = false;
      });
    } else {
      // Failure: Handle the empty list or error case
      if (kDebugMode) {
        print('Failure: No REQUESTS transactions found or an error occurred');
      }
      arrAllUser.clear();
      arrAllUser = [];
      setState(() {
        resultLoader = false;
        screenLoader = false;
      });
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
        color: Colors.amber,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: screenLoader == true
          ? customCircularProgressIndicator()
          : arrAllUser.isEmpty
              ? Center(
                  child: textFontPOOPINS(
                    'No request found',
                    Colors.white,
                    12.0,
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _UIKitRequestHistoryAfterBG(context),
                ),
    );
  }

  String calculateTotalAmount(String amount, String adminCharge) {
    // Parse the strings to double and handle potential parsing issues
    double amountValue = double.tryParse(amount) ?? 0.0;
    double adminChargeValue = double.tryParse(adminCharge) ?? 0.0;

    // Add the values together
    double total = amountValue + adminChargeValue;

    // Return the result as a formatted string (e.g., with 2 decimal places)
    return total.toStringAsFixed(2);
  }

  String calculateTotalAmountMinus(String amount, String adminCharge) {
    // Parse the strings to double and handle potential parsing issues
    double amountValue = double.tryParse(amount) ?? 0.0;
    double adminChargeValue = double.tryParse(adminCharge) ?? 0.0;

    // Add the values together
    double total = amountValue - adminChargeValue;

    // Return the result as a formatted string (e.g., with 2 decimal places)
    return '\$${total.toStringAsFixed(1)}';
  }

  String calculateAfterConvenienceFee(String amount, String adminCharge) {
    // Parse the strings to double and handle potential parsing issues

    double amountValueF = double.tryParse(amount) ?? 0.0;
    double adminChargeValueF = double.tryParse(adminCharge) ?? 0.0;

    // Add the values together
    double totalF = amountValueF + adminChargeValueF;

    // Add the values together
    double total = totalF - adminChargeValueF;
    debugPrint(total.toString());

    // Return the result as a formatted string (e.g., with 2 decimal places)
    return total.toStringAsFixed(2);
  }

  Widget _UIKitRequestHistoryAfterBG(context) {
    return Column(
      children: [
        const SizedBox(
          height: 80.0,
        ),
        customNavigationBarForMenu(
          'Request History',
          _scaffoldKey,
        ),
        //
        const SizedBox(height: 20),
        for (int i = 0; i < arrAllUser.length; i++) ...[
          if (arrAllUser[i]['senderId'].toString() ==
              strLoginUserId.toString()) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: textFontPOOPINS(
                  //
                  'Request from ${arrAllUser[i]['userName']}',
                  Colors.black,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: textFontPOOPINS(
                  //
                  'Payment status: pending',
                  Colors.grey,
                  12.0,
                  fontWeight: FontWeight.w500,
                ),
                trailing: Container(
                  width: 120,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.south_west,
                            size: 16.0,
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(width: 4.0),
                          textFontORBITRON(
                            //
                            arrAllUser[i]['amount'].toString(),
                            /*calculateTotalAmount(
                              arrAllUser[i]['amount'].toString(),
                              arrAllUser[i]['admincharge'].toString(),
                            ),*/

                            Colors.orangeAccent,
                            18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          arrAllUser[i]['trn_date'].toString() == ''
                              ? textFontPOOPINS(
                                  // sv
                                  '',
                                  Colors.grey,
                                  8.0,
                                  fontWeight: FontWeight.w500,
                                )
                              : textFontPOOPINS(
                                  // sv
                                  formatDate(
                                      arrAllUser[i]['trn_date'].toString()),
                                  Colors.grey,
                                  8.0,
                                  fontWeight: FontWeight.w500,
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _showAlertDialog(context, arrAllUser[i]);
                },
              ),
            ),
          ] else ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: textFontPOOPINS(
                  //
                  'Request from you',
                  Colors.black,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: textFontPOOPINS(
                  //
                  'To: ${arrAllUser[i]['sender_userName']}',
                  Colors.grey,
                  12.0,
                  fontWeight: FontWeight.w500,
                ),
                trailing: Container(
                  width: 120,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /*const Icon(
                            Icons.south_west,
                            size: 16.0,
                            color: Colors.orangeAccent,
                          ),*/
                          const SizedBox(width: 4.0),
                          textFontORBITRON(
                            //
                            arrAllUser[i]['amount'].toString(),
                            /*calculateTotalAmount(
                                arrAllUser[i]['amount'].toString(),
                                arrAllUser[i]['admincharge'].toString()),*/
                            Colors.orangeAccent,
                            18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          arrAllUser[i]['trn_date'].toString() == ''
                              ? textFontPOOPINS(
                                  // sv
                                  '',
                                  Colors.grey,
                                  8.0,
                                  fontWeight: FontWeight.w500,
                                )
                              : textFontPOOPINS(
                                  // sv
                                  formatDate(
                                      arrAllUser[i]['trn_date'].toString()),
                                  Colors.grey,
                                  8.0,
                                  fontWeight: FontWeight.w500,
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  debugPrint('REQUEST FROM YOU');
                  _openBottomSheet(
                    context,
                    arrAllUser[i]['amount'].toString(),
                    arrAllUser[i]['admincharge'].toString(),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 8.0),
        ]
      ],
    );
  } // API

  void _openBottomSheet(
    BuildContext context,
    requestAmount,
    adminCharge,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                textFontPOOPINS(
                  'Invoice',
                  Colors.black,
                  16.0,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    textFontPOOPINS(
                      'Requested amount:',
                      Colors.black,
                      16.0,
                    ),
                    const Spacer(),
                    textFontPOOPINS(
                      '\$$requestAmount',
                      // '\$${calculateTotalAmount(requestAmount, adminCharge)}',
                      Colors.black,
                      16.0,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    textFontPOOPINS(
                      'Convenience fee:',
                      Colors.black,
                      16.0,
                    ),
                    const Spacer(),
                    textFontPOOPINS(
                      '\$$adminCharge',
                      Colors.black,
                      16.0,
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Row(
                  children: [
                    textFontPOOPINS('You will get:', Colors.black, 20.0,
                        fontWeight: FontWeight.bold),
                    const Spacer(),
                    textFontPOOPINS(
                        // requestAmount,
                        // '\$${calculateAfterConvenienceFee(requestAmount, adminCharge)}',
                        calculateTotalAmountMinus(
                          requestAmount,
                          adminCharge,
                        ),
                        Colors.black,
                        20.0,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textFontPOOPINS(
            'Details',
            Colors.black,
            18.0,
            fontWeight: FontWeight.w600,
          ),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                const SizedBox(height: 20),
                textFontPOOPINS(
                  'Request from: ${user['userName']}',
                  Colors.black,
                  14.0,
                ),
                const SizedBox(height: 20),
                textFontPOOPINS(
                  'Transaction Id: ${user['transactionId']}',
                  Colors.black,
                  14.0,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: textFontPOOPINS(
                'Decline',
                Colors.red,
                12.0,
                fontWeight: FontWeight.w400,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _acceptDeclineAPI(
                  context,
                  user['transactionId'].toString(),
                  'decline',
                  '',
                );
              },
            ),
            TextButton(
              child: textFontPOOPINS(
                'Accept & Pay',
                Colors.green,
                14.0,
                fontWeight: FontWeight.w600,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _acceptDeclineAPI(
                  context,
                  user['transactionId'].toString(),
                  'approve',
                  user['amount'].toString(),
                  // '\$${calculateAfterConvenienceFee(user['amount'].toString(), user['admincharge'].toString())}',
                  /*calculateTotalAmount(
                    user['amount'].toString(),
                    user['admincharge'].toString(),
                  ),*/
                );
              },
            ),
          ],
        );
      },
    );
  }

  /*void _showBottomSheet(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.check),
                title: Text('Accept'),
                onTap: () {
                  // Handle accept action
                  Navigator.pop(context);
                  _acceptDeclineAPI(
                    context,
                    user['transactionId'].toString(),
                    'approve',
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.close),
                title: Text('Decline'),
                onTap: () {
                  // Handle decline action
                  Navigator.pop(context);
                  _acceptDeclineAPI(
                    context,
                    user['transactionId'].toString(),
                    'decline',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }*/

  _acceptDeclineAPI(
    context,
    transactionId,
    status,
    requestAmount,
  ) async {
    debugPrint('API ==> REQUEST HISTORYE');
    // showLoadingUI(context, 'sending...');
    // validate
    // storeUserWalletAmount
    //

    // check before send requested money
    double doubleWalletAmount = double.parse(storeUserWalletAmount.toString());
    double doubleRequestAmount = double.parse(requestAmount.toString());
    logger.d('Wallet balance:==> $doubleWalletAmount');
    logger.d('Request amount:==> $doubleRequestAmount');
    if (doubleWalletAmount < doubleRequestAmount) {
      dismissKeyboard(context);
      customToast(
        'Not enough money in your wallet. Please recharge your wallet first.',
        Colors.redAccent,
        ToastGravity.BOTTOM,
      );
      return;
    }

    customToast(
      'please wait...',
      Colors.green,
      ToastGravity.BOTTOM,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();

    final parameters = {
      'action': 'requestmoneyaccept',
      'userId': userId,
      'transactionId': transactionId,
      'status': status,
    };
    // if (kDebugMode) {
    logger.d(parameters);
    // }
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
        print('STATUS ==> $successStatus$successStatus');
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
            _acceptDeclineAPI(context, transactionId, status, requestAmount);
          });
        } else {
          //
          if (kDebugMode) {
            print('object');
            print(successStatus.toLowerCase());
          }
          if (successStatus.toLowerCase() == 'success') {
            // Navigator.pop(context);

            customToast(
              'Request approved successfully.',
              Colors.green,
              ToastGravity.BOTTOM,
            );
            _allRecentTransaction(context);
            // Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => BottomBar(
            //       selectedIndex: 2,
            //     ),
            //   ),
            // );
          } else {
            customToast(
              successMessage,
              Colors.green,
              ToastGravity.BOTTOM,
            );
            _allRecentTransaction(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => BottomBar(
            //       selectedIndex: 2,
            //     ),
            //   ),
            // );
          }
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }
}



// action:requestmoneyaccept
// transactionId:69
// status:  //approve   decline
// userId:

