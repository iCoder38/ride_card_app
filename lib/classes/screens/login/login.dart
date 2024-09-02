import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/bottom_bar/bottom_bar.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';
import 'package:ride_card_app/classes/screens/register/register.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  final TextEditingController _contEmail = TextEditingController();
  final TextEditingController _contPassword = TextEditingController();
  bool evsRegistered = false;
  //
  @override
  void initState() {
    // _sendToLogin(context);

    super.initState();
  }

  @override
  void dispose() {
    _contEmail.dispose();
    _contPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _UIKit(context),
    );
  }

  Widget _UIKit(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.amber,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover, // Ensure the image covers the whole container
        ),
      ),
      child: _UIKitStackBG(context),
    );
  }

  Widget _UIKitStackBG(context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(
              height: 80.0,
            ),
            customNavigationBar(context, 'Login'),
            GestureDetector(
              onTap: () {},
              child: Container(
                  margin: const EdgeInsets.only(top: 40.0),
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      24.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
            const SizedBox(
              height: 40.0,
            ),
            // const Spacer(),
            const SizedBox(
              height: 200,
            ),
            textFontPOOPINS(
              'Sign in to your account',
              Colors.white,
              16.0,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
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
                    controller: _contEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10.0,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: svgImage(
                          'email',
                          14.0,
                          14.0,
                        ),
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
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
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
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
                    obscureText: true,
                    controller: _contPassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10.0,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: svgImage(
                          'lock',
                          14.0,
                          14.0,
                        ),
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
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
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    showLoadingUI(context, PLEASE_WAIT);
                    /**/
                    _sendToLogin(context);
                    //  _sendRequestToRegister(context);
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
                      'SIGN IN',
                      Colors.white,
                      18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFontPOOPINS(
                  'Forgot password ? - ',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
                textFontPOOPINS(
                  'Click here',
                  hexToColor(appORANGEcolorHexCode),
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
    );
  }

  void _sendToLogin(context) async {
    debugPrint('API ==> LOGIN');

    final parameters = {
      'action': 'login',
      'email': _contEmail.text,
      'password': _contPassword.text,
    };
    if (kDebugMode) {
      print(parameters);
    }
    // return;
    try {
      final response = await _apiService.postRequest(parameters, '');
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];

      if (response.statusCode == 200) {
        debugPrint('LOGIN: RESPONSE ==> SUCCESS');
        //
        if (successMessage == 'Email or password is wrong.') {
          //
          Navigator.pop(context);
          customToast(successMessage, Colors.red, ToastGravity.TOP);
        } else {
          //
          if (successStatus == 'success') {
            SharedPreferences prefs2 = await SharedPreferences.getInstance();
            prefs2.setString('Key_save_login_user_id',
                jsonResponse['data']['userId'].toString());
            prefs2.setString(
              'key_save_user_role',
              jsonResponse['data']['role'].toString(),
            );
            //
            evsRegistered = true;
            _loginViaFirebase(
              context,
              jsonResponse['data']['fullName'],
              jsonResponse['data']['lastName'],
              jsonResponse['data']['email'],
            );
          } else {
            customToast(
              'Something went wrong with server',
              Colors.red,
              ToastGravity.TOP,
            );
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

  Future<void> _loginViaFirebase(context, firstName, lastName, email) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth
          .signInWithEmailAndPassword(
              email: _contEmail.text.toString(),
              password: 'firebase_password_rca_!')
          .then((v) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomBar(selectedIndex: 0),
          ),
        );
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      } // Handle errors here
      debugPrint('FIREBASE ERROR');
      if (evsRegistered == true) {
        //
        createAnAccountInFirebase(context, firstName, lastName, email);
      }
    }
  }

  createAnAccountInFirebase(context, firstName, lastName, email) async {
    //
    debugPrint('==================================================');
    debugPrint('============= FIREBASE ===========================');
    // showLoadingUI(context, PLEASE_WAIT);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.toString(),
            password: 'firebase_password_rca_!',
          )
          .then((value) => {
                //
                // debugPrint('REGISTERED IN FIREBASE'),
                updateUserName(context, firstName, lastName)
                //
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.pop(context);
        customToast(
          'The password provided is too weak.',
          Colors.redAccent,
          ToastGravity.TOP,
        );
      } else if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
        customToast(
          //
          TEXT_ALREADY_BEEN_EXIST,
          hexToColor(appREDcolorHexCode),
          ToastGravity.TOP,
        );
      } else {
        debugPrint('Error');
        /*Navigator.pop(context);
        customToast(
          //
          TEXT_F_ERROR,
          Colors.redAccent,
          ToastGravity.TOP,
        );*/
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Navigator.pop(context);
    }
  }

  updateUserName(context, firstName, lastName) async {
    var mergeName = '$firstName $lastName';
    debugPrint(mergeName);
    await FirebaseAuth.instance.currentUser!
        .updateDisplayName(mergeName)
        .then((v) {
      debugPrint('REGISTERED NAME ALSO');
      //
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomBar(selectedIndex: 0),
        ),
      );
    });
  }
}
