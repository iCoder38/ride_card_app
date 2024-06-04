import 'dart:io';
import 'dart:convert';

// import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/hive/hive.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //
  var screenLoader = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  final TextEditingController _contFirstName = TextEditingController();
  final TextEditingController _contLastName = TextEditingController();
  final TextEditingController _contEmail = TextEditingController();
  final TextEditingController _contPhone = TextEditingController();
  // final TextEditingController _contPassword = TextEditingController();
  File? imageFile;
  var myFullData;
  //
  @override
  void initState() {
    //
    fetchProfileData();
    super.initState();
  }

  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) {
      myFullData = v;
      // print(v.runtimeType);
      parseValue();
    });
    // print(responseBody);
  }

  parseValue() {
    //
    _contFirstName.text = myFullData['data']['fullName'];
    _contLastName.text = myFullData['data']['lastName'];
    _contEmail.text = myFullData['data']['email'];
    _contPhone.text = myFullData['data']['contactNumber'];

    setState(() {
      screenLoader = false;
    });
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
        child: screenLoader == true ? const SizedBox() : _UIKitStackBG(context),
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
            customNavigationBarForMenu('Edit profile', _scaffoldKey),
            GestureDetector(
              onTap: () {
                // openGalleryOrCamera(context);
              },
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
                child: imageFile == null
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            24.0,
                          ),
                          child: Image.file(
                            File(imageFile!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            // height: 200,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
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
                          controller: _contFirstName,
                          decoration: InputDecoration(
                            hintText: 'First name',
                            border: InputBorder.none, // Remove the border
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10.0,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: svgImage('user', 14.0, 14.0),
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
                    width: 10.0,
                  ),
                  Expanded(
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
                          controller: _contLastName,
                          decoration: InputDecoration(
                            hintText: 'Last name',
                            border: InputBorder.none, // Remove the border
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10.0,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: svgImage('user', 14.0, 14.0),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 219, 218, 218),
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    readOnly: true,
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
                        child: svgImage('email', 14.0, 14.0),
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
                    controller: _contPhone,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10.0,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: svgImage('phone', 14.0, 14.0),
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
            /*Padding(
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
                    controller: _contPassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
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
            ),*/
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
                    _sendRequestToUpdateProfile(context);
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
                      'UPDATE',
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

  // API
  void _sendRequestToUpdateProfile(context) async {
    debugPrint('API ==> COMPLETE PROFILE');
    String parseDevice = await deviceIs();
    var box = await Hive.openBox<MyData>('myBox1');
    var myData = box.getAt(0);
    await box.close();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString('key_save_token_locally'));
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();

    // print(prefs.getString('key_save_token_locally'));
    var userId = prefs.getString('Key_save_login_user_id').toString();

    final parameters = {
      'action': 'editProfile',
      'userId': userId,
      'fullName': _contFirstName.text,
      'lastName': _contLastName.text,
      'email': _contEmail.text,
      'contactNumber': _contPhone.text,
      'role': RESPONSE_ROLE,
      'device': parseDevice,
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
            _sendRequestToUpdateProfile(context);
          });
        } else {
          //
          successStatus.toLowerCase() == 'success'
              ? successfullyCreatedAccount(successStatus, successMessage)
              : Navigator.pop(context);
          /*customToast(
            successStatus,
            hexToColor(appREDcolorHexCode),
            ToastGravity.TOP,
          );*/
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  successfullyCreatedAccount(status, message) {
    //
    customToast(message, Colors.green, ToastGravity.TOP);
    Navigator.pop(context);
  }
}
