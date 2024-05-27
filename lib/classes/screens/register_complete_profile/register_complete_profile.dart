import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/hive/hive.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';
import 'package:ride_card_app/classes/screens/register_complete_profile_business/register_complete_profile_business.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  //
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contPlaceOfWork = TextEditingController();
  final TextEditingController _contSalary = TextEditingController();
  final TextEditingController _contAddress = TextEditingController();
  final TextEditingController _contCity = TextEditingController();
  final TextEditingController _contPostalCode = TextEditingController();
  final TextEditingController _contCountry = TextEditingController();
  final TextEditingController _contPEP = TextEditingController();
  final TextEditingController _contPassport = TextEditingController();
  final TextEditingController _contPassportVerification =
      TextEditingController();
  //

  var _email = '';

  @override
  void initState() {
    _email = FirebaseAuth.instance.currentUser!.email.toString();
    super.initState();
  }

  @override
  void dispose() {
    _contPlaceOfWork.dispose();
    _contSalary.dispose();
    _contAddress.dispose();
    _contCity.dispose();
    _contPostalCode.dispose();
    _contCountry.dispose();
    _contPEP.dispose();
    _contPassport.dispose();
    _contPassportVerification.dispose();
    super.dispose();
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
        color: Colors.amber,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _UIKitCompleteProfileAfterBG(context),
      ),
    );
  }

  Widget _UIKitCompleteProfileAfterBG(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          customNavigationBar(context, TEXT_NAVIGATION_TITLE_COMPLETE_PROFILE),
          _textFieldPlaceOfWork(),
          _textFieldSalary(),
          _textFieldAddress(),
          _textFieldPostalCode(),
          _textFieldPEP(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: textFontPOOPINS(
              //
              TEXT_FIELD_KYC,
              Colors.white,
              14.0,
            ),
          ),
          _textFieldPassport(),
          _textFieldPassportVerification(),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            child: GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  showLoadingUI(context, PLEASE_WAIT);
                  //
                  _sendRequestToCompleteProfile(context);
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
                    TEXT_CREATE_AN_ACCOUNT,
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
    );
  }

  Padding _textFieldPlaceOfWork() {
    return Padding(
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
            controller: _contPlaceOfWork,
            decoration: const InputDecoration(
              hintText: 'Place of work',
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
    );
  }

  Padding _textFieldPassportVerification() {
    return Padding(
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
            controller: _contPassportVerification,
            decoration: const InputDecoration(
              hintText: 'Passport verification',
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
    );
  }

  Padding _textFieldPassport() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        // top: 16.0,
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
            controller: _contPassport,
            decoration: const InputDecoration(
              hintText: 'Passport',
              border: InputBorder.none, // Remove the border
              filled: false,
              contentPadding: EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 10.0,
              ),
              suffixIcon: Icon(
                Icons.arrow_drop_down,
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
    );
  }

  Padding _textFieldPEP() {
    return Padding(
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
            controller: _contPEP,
            decoration: const InputDecoration(
              hintText: 'PEP ( Politically Exposed Person )',
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
    );
  }

  Padding _textFieldPostalCode() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
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
                  controller: _contPostalCode,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Postal code',
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
                  maxLength: 6,
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
                  controller: _contCountry,
                  decoration: const InputDecoration(
                    hintText: 'Country',
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
        ],
      ),
    );
  }

  Padding _textFieldAddress() {
    return Padding(
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
                  controller: _contAddress,
                  decoration: const InputDecoration(
                    hintText: 'Address',
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
                  controller: _contCity,
                  decoration: const InputDecoration(
                    hintText: 'City',
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
        ],
      ),
    );
  }

  Padding _textFieldSalary() {
    return Padding(
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
            controller: _contSalary,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Salary ( per month )',
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
    );
  }

  // API
  void _sendRequestToCompleteProfile(context) async {
    debugPrint('API ==> COMPLETE PROFILE');

    var box = await Hive.openBox<MyData>('myBox1');
    var myData = box.getAt(0);
    await box.close();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString('key_save_token_locally'));
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();

    final parameters = {
      'action': 'editProfile',
      'userId': myData!.userId,
      'PlaceOfWork': _contPlaceOfWork.text,
      'Salary': _contSalary.text,
      'address': _contAddress.text,
      'City': _contCity.text,
      'zipcode': _contPostalCode.text,
      'country': _contCountry.text,
      'PEP': _contPEP.text,
      'Passport': _contPassport.text,
      'passport_verification': _contPassportVerification.text,
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
              .generateToken(myData.userId, _email, myData.role)
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            _sendRequestToCompleteProfile(context);
          });
        } else {
          //
          successStatus.toLowerCase() == 'success'
              ? successfullyCreatedAccount(successStatus, successMessage)
              : Navigator.pop(context);
          customToast(
              successStatus, hexToColor(appREDcolorHexCode), ToastGravity.TOP);
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
    customToast(message, Colors.green, ToastGravity.BOTTOM);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CardsScreen()),
    );
  }
}
