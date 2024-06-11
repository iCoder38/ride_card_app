import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/request_money/request_money.dart';
import 'package:ride_card_app/classes/screens/success/success.dart';
import 'package:ride_card_app/classes/screens/wallet/add_money/add_money.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendMoneyPortalScreen extends StatefulWidget {
  const SendMoneyPortalScreen({super.key, this.data});

  final data;
  @override
  State<SendMoneyPortalScreen> createState() => _SendMoneyPortalScreenState();
}

class _SendMoneyPortalScreenState extends State<SendMoneyPortalScreen> {
  //
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController firstController = TextEditingController();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  bool screenLoader = true;
  var myFullData;
  var myCurrentBalance;
  //
  @override
  void initState() {
    if (kDebugMode) {
      print(widget.data);
    }
    //
    fetchProfileData();
    super.initState();
  }

  @override
  void dispose() {
    firstController.dispose();
    super.dispose();
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
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _UIKitCardsAfterBG(context),
      ),
    );
  }

  Widget _UIKitCardsAfterBG(BuildContext context) {
    return screenLoader == true
        ? const SizedBox()
        : Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 80.0,
                ),
                customNavigationBar(
                  context,
                  TEXT_NAVIGATION_TITLE_SEND_MONEY,
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
                                      // sd
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
                              pushToAddMoney(
                                context,
                              );
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: hexToColor(appREDcolorHexCode),
                                    borderRadius: BorderRadius.circular(
                                      16.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: textFontPOOPINS(
                                      'Add money',
                                      Colors.white,
                                      14.0,
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
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            40.0,
                          ),
                          child: Image.network(
                            // sd
                            widget.data['profile_picture'],
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      title: textFontPOOPINS(
                        // sd
                        widget.data['userName'],
                        Colors.black,
                        18.0,
                      ),
                      subtitle: textFontPOOPINS(
                        // sd
                        widget.data['usercontactNumber'],
                        Colors.grey,
                        12.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      60.0,
                    ),
                  ),
                  child: Image.asset('assets/images/payment.png'),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                textFontPOOPINS(
                  //
                  'Enter amount to send',
                  appORANGEcolor,
                  16.0,
                  fontWeight: FontWeight.w600,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                  ),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: Center(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        controller: firstController,
                        decoration: const InputDecoration(
                          hintText: '\$0.0',
                          border: InputBorder.none, // Remove the border
                          filled: false,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10.0),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 24.0,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return TEXT_FIELD_EMPTY_TEXT;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _sendMoney(context, widget.data['userId'].toString(),
                            firstController.text.toString(), '1');
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: hexToColor(appREDcolorHexCode),
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                          child: Center(
                            child: textFontPOOPINS(
                              'Send money',
                              Colors.white,
                              22.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  // EVS: API => GET USER PROFILE DATA
  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) {
      myFullData = v;

      debugPrint(myFullData['data']['wallet'].toString());
      // current wallet balance
      if (myFullData['data']['wallet'].toString() == '') {
        myCurrentBalance = '0';
      } else {
        myCurrentBalance = myFullData['data']['wallet'].toString();
      }

      setState(() {
        screenLoader = false;
      });
    });
    // print(responseBody);
  }

  // send money
// API
  void _sendMoney(context, String receiverId, String amount, status) async {
    debugPrint('API ==> SEND MONEY');

    if (status == '1') {
      showLoadingUI(context, 'sending...');
    }

    // customToast('adding please wait...', Colors.green, ToastGravity.BOTTOM);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();

    final parameters = {
      'action': 'sendmoney',
      'senderId': userId,
      'userId': receiverId, // receiverId
      'amount': amount,
      'type': 'Send',
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
            _sendMoney(context, receiverId, amount, '0');
          });
          //
        } else {
          //
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
