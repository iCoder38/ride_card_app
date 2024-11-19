import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/service/service/service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, required this.emailAddress});
  final String emailAddress;
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  Widget _UIKitStackBG(BuildContext context) {
    return Column(
      children: [
        // Main content of the screen
        const SizedBox(height: 80),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customNavigationBar(context, 'Reset password'),
            const SizedBox(height: 40),
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
                    controller: otpController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'OTP',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10.0,
                      ),
                      /*suffixIcon: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: svgImage(
                          'email',
                          14.0,
                          14.0,
                        ),
                      ),*/
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
            const SizedBox(height: 16),
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
                    controller: passwordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10.0,
                      ),
                      /*suffixIcon: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: svgImage(
                          'email',
                          14.0,
                          14.0,
                        ),
                      ),*/
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
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: GestureDetector(
                onTap: () async {
                  /*if (_formKey.currentState!.validate()) {
                    showLoadingUI(context, PLEASE_WAIT);
                    /**/
                    _sendToLogin(context);
                    //  _sendRequestToRegister(context);
                  }*/
                  handleSubmit();
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
                      'Reset password',
                      Colors.white,
                      18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Loading indicator overlay
      ],
    );
  }

  Future<void> handleSubmit() async {
    if (otpController.text == '') {
      dismissKeyboard(context);
      customToast('Field should not be empty', Colors.red, ToastGravity.BOTTOM);
      return;
    }
    if (passwordController.text == '') {
      dismissKeyboard(context);
      customToast('Field should not be empty', Colors.red, ToastGravity.BOTTOM);
      return;
    }
    showLoadingUI(context, 'Please wait...');
    resetOTP(context, otpController.text, passwordController.text);
  }

  void resetOTP(context, otp, password) async {
    debugPrint('API ==> RESET OTP');
    //showLoadingUI(context, 'please wait...');
    final parameters = {
      'action': 'resetpassword',
      'email': widget.emailAddress,
      'OTP': otp,
      'password': password,
    };

    if (kDebugMode) {
      logger.d(parameters);
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
        debugPrint('RESET: RESPONSE ==> SUCCESS');
        //
        if (successMessage == 'OTP not valid') {
          dismissKeyboard(context);
          Navigator.pop(context);
          customToast(successMessage, Colors.red, ToastGravity.TOP);
          //  Navigator.pop(context);
        } else if (successMessage == 'Email or password is wrong.') {
          //
          dismissKeyboard(context);
          Navigator.pop(context);
          customToast(successMessage, Colors.red, ToastGravity.TOP);
        } else {
          //
          if (successStatus == 'success') {
            logger.d(jsonResponse);
            dismissKeyboard(context);
            Navigator.pop(context);
            customToast(successMessage, Colors.green, ToastGravity.BOTTOM);
            Navigator.pop(context);
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
}
