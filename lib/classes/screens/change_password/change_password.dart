import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/change_password/service/service.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contOldPassword = TextEditingController();
  final TextEditingController _contNewPassword = TextEditingController();
  final TextEditingController _contReEnterPassword = TextEditingController();
  //
  @override
  void dispose() {
    //
    _contOldPassword.dispose();
    _contNewPassword.dispose();
    _contReEnterPassword.dispose();
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
            customNavigationBarForMenu('Change password', _scaffoldKey),
            //
            Container(
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
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            textFontPOOPINS(
              'Change password',
              Colors.white,
              20.0,
              fontWeight: FontWeight.w400,
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
                    controller: _contOldPassword,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Old password',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
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
                    controller: _contNewPassword,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'New password',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
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
                    controller: _contReEnterPassword,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Re-enter password',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
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
                    _changePasswordAPI(context);
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
                      'Update',
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
      ),
    );
  }

  //
  void _changePasswordAPI(context) async {
    if (_contNewPassword.text != _contReEnterPassword.text) {
      dismissKeyboard(context);
      customToast(
        'Password not matched',
        Colors.redAccent,
        ToastGravity.BOTTOM,
      );
      return;
    }
    // showLoadingUI(context, 'updating...');
    debugPrint('API ==> CHANGE PASSWORD');

    String result = await AuthServiceForChangePassword().changePassword(
      _contNewPassword.text,
      _contReEnterPassword.text,
      _contOldPassword.text,
      showLoadingUI,
      customToast,
      dismissKeyboard,
      context,
    );
    if (kDebugMode) {
      print('result ==> $result');
    }
    // customToast(successMessage, Colors.green, ToastGravity.BOTTOM);

    if (result == 'failure') {
      // Handle failure case
      dismissKeyboard(context);
      debugPrint('failure');
    } else if (result == 'unauthorized') {
      // Handle unauthorized case
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
      var userId = prefs.getString('Key_save_login_user_id').toString();
      var roleIs = '';
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
        // again click
        _changePasswordAPI(context);
      });
      debugPrint('UNAUTHORIZE');
    } else {
      if (result == 'Current password does not match.') {
        dismissKeyboard(context);
        Navigator.pop(context);
        // customToast(
        //   'Current password does not match',
        //   Colors.red,
        //   ToastGravity.BOTTOM,
        // );
      } else {
        success(result);
      }
      //
    }

    /* SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();

    final parameters = {
      'action': 'changepassword',
      'userId': userId,
      'newPassword': _contNewPassword.text,
      'oldPassword': _contOldPassword.text,
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
                  userId, FirebaseAuth.instance.currentUser!.email, 'Member')
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            _changePasswordAPI(context);
          });
        } else {
          //
          if (successStatus == 'Fails') {
          } else {
            success(successMessage);
          }
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }*/
  }

  success(successMessage) {
    dismissKeyboard(context);
    _contOldPassword.text = '';
    _contNewPassword.text = '';
    _contReEnterPassword.text = '';
    //
    Navigator.pop(context);
    customToast(
      successMessage,
      Colors.green,
      ToastGravity.BOTTOM,
    );
  }
}
