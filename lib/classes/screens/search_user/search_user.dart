import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/send_money_portal/send_money_portal.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  //
  String? resultFound = 's';
  var screenLoader = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  final TextEditingController _contUser = TextEditingController();
  var arrAllUser = [];
  bool isDataShow = false;
  //
  bool resultLoader = true;
  //
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
        color: Colors.amber,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _UIKitStackBG(context),
      ),
    );
  }

  SingleChildScrollView _UIKitStackBG(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            //
            const SizedBox(
              height: 80.0,
            ),
            customNavigationBar(context, 'Search'),
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
                    controller: _contUser,
                    // keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'enter name...',
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10.0,
                      ).copyWith(
                        // Adjust the top padding to center the hint text vertically
                        top: 14.0,
                      ),
                      suffixIcon: const Icon(Icons.search),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                    ),
                    // onChanged: (value) {
                    //   print(value);
                    //   _searchUser(context, value);
                    // },
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
            //
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    showLoadingUI(context, 'searching...');
                    //
                    _searchUser(context);
                  }
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: appREDcolor,
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                  ),
                  child: Center(
                    child: textFontPOOPINS(
                      //
                      'Search',
                      Colors.white,
                      18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            if (resultFound == '1') ...[
              textFontOPENSANS('', Colors.white, 14.0),
            ] else if (resultFound == '0') ...[
              const SizedBox(height: 40),
              textFontOPENSANS('No result found', Colors.white, 14.0),
            ] else if (resultFound == 's') ...[
              textFontOPENSANS('', Colors.white, 14.0),
            ],

            //
            resultLoader == true
                ? const SizedBox()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: resultFound == '0'
                              ? textFontPOOPINS(
                                  '',
                                  Colors.white,
                                  24.0,
                                  fontWeight: FontWeight.w600,
                                )
                              : textFontPOOPINS(
                                  'Results',
                                  Colors.white,
                                  24.0,
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                      ),
                      for (int i = 0; i < arrAllUser.length; i++) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 24.0,
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
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(
                                    40.0,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    40.0,
                                  ),
                                  child: arrAllUser[i]['profile_picture'] == ''
                                      ? const SizedBox()
                                      : Image.network(
                                          arrAllUser[i]['profile_picture'],
                                          fit: BoxFit.fitWidth,
                                        ),
                                ),
                              ),
                              title: textFontPOOPINS(
                                //
                                arrAllUser[i]['userName'],
                                Colors.black,
                                18.0,
                              ),
                              subtitle: textFontPOOPINS(
                                //
                                arrAllUser[i]['usercontactNumber'],
                                Colors.grey,
                                12.0,
                              ),
                              onTap: () {
                                //
                                openSendRequestMoney(context, arrAllUser[i]);
                              },
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void openSendRequestMoney(
    BuildContext context,
    data,
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
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      //

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendMoneyPortalScreen(
                            data: data,
                            title: '1',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // svgImage('camera', 16.0, 16.0),
                            // const SizedBox(
                            //   width: 8.0,
                            // ),
                            textFontPOOPINS(
                              'Send money',
                              Colors.black,
                              12.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      //
                      Navigator.pop(context);
                      //
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendMoneyPortalScreen(
                            data: data,
                            title: '2',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // svgImage('video', 16.0, 16.0),
                            // const SizedBox(
                            //   width: 8.0,
                            // ),
                            textFontPOOPINS(
                              'Request money',
                              Colors.black,
                              12.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                      child: textFontPOOPINS(
                        'Dismiss',
                        Colors.redAccent,
                        12.0,
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

// API
  void _searchUser(context) async {
    debugPrint('API ==> SEARCH USER');
    arrAllUser.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString('key_save_token_locally'));
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();

    // print(prefs.getString('key_save_token_locally'));
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {
      'action': 'userlist',
      'userId': userId,
      'keyword': _contUser.text.toString(),
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
            _searchUser(context);
          });
        } else {
          //
          arrAllUser = jsonResponse['data'];
          if (arrAllUser.isEmpty) {
            setState(() {
              resultFound = '0';
            });
          } else {
            setState(() {
              resultFound = '1';
            });
          }

          if (kDebugMode) {
            print(arrAllUser);
          }
          Navigator.pop(context);
          setState(() {
            resultLoader = false;
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

  successfullyCreatedAccount(status, message) {
    //
    customToast(message, Colors.green, ToastGravity.TOP);
    Navigator.pop(context);
  }
}
