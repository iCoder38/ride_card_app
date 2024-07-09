import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';

class BusinessCompleteProfileScreen extends StatefulWidget {
  const BusinessCompleteProfileScreen({super.key});

  @override
  State<BusinessCompleteProfileScreen> createState() =>
      _BusinessCompleteProfileScreenState();
}

class _BusinessCompleteProfileScreenState
    extends State<BusinessCompleteProfileScreen> {
  //
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contName = TextEditingController();
  final TextEditingController _contEmail = TextEditingController();
  final TextEditingController _contPhone = TextEditingController();
  final TextEditingController _contDBA = TextEditingController();
  final TextEditingController _contDOB = TextEditingController();
  final TextEditingController _contSalary = TextEditingController();
  final TextEditingController _contAnnualIncome = TextEditingController();
  final TextEditingController _contSourceOfIncome = TextEditingController();
  final TextEditingController _contOccupation = TextEditingController();
  final TextEditingController _contAddress = TextEditingController();
  final TextEditingController _contStreet = TextEditingController();
  final TextEditingController _contCity = TextEditingController();
  final TextEditingController _contState = TextEditingController();
  final TextEditingController _contPostalCode = TextEditingController();
  final TextEditingController _contCountry = TextEditingController();
  final TextEditingController _contSSN = TextEditingController();
  // business
  final TextEditingController _contStateOfIncorporation =
      TextEditingController();
  //
  @override
  void dispose() {
    _contName.dispose();
    _contEmail.dispose();
    _contPhone.dispose();
    _contDBA.dispose();
    _contDOB.dispose();
    _contSalary.dispose();
    _contAddress.dispose();
    _contCity.dispose();
    _contPostalCode.dispose();
    _contCountry.dispose();
    //  _contPEP.dispose();
    // _contPassport.dispose();
    // _contPassportVerification.dispose();
    _contAnnualIncome.dispose();
    _contSourceOfIncome.dispose();
    _contStreet.dispose();
    _contCity.dispose();
    _contSSN.dispose();
    _contOccupation.dispose();
    // business
    _contStateOfIncorporation.dispose();

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
          customNavigationBar(context, 'Registration'),

          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'PERSONAL INFO',
                  Colors.white,
                  24.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Date of birth',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          _textFieldPlaceOfWork(),
          //
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Occupation',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          //  _textFieldOccupation(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Annual Income',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          // _textFieldAnnualIncome(),
          //
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Source of Income',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          // _textFieldSourceOfIncome(),
          //

          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Name',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 0,
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
                  controller: _contName,
                  decoration: const InputDecoration(
                    hintText: 'Name ',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
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
          // email
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Email',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 0,
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
                  keyboardType: TextInputType.emailAddress,
                  controller: _contEmail,
                  decoration: const InputDecoration(
                    hintText: 'Email ',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
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
          // phone
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Phone',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 0,
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
                  decoration: const InputDecoration(
                    hintText: 'Phone ',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
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

          //
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Doing business as ( optional )',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 0,
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
                  controller: _contDBA,
                  decoration: const InputDecoration(
                    hintText: 'Doing business as',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                  ),
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return TEXT_FIELD_EMPTY_TEXT;
                    }
                    return null;
                  },*/
                ),
              ),
            ),
          ),
          //

          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Street',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 0,
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
                  controller: _contAddress,
                  decoration: const InputDecoration(
                    hintText: 'Street ',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
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
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'City',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 0,
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
                  controller: _contCity,
                  decoration: const InputDecoration(
                    hintText: 'City',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
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
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'State',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 0,
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
                  controller: _contState,
                  decoration: const InputDecoration(
                    hintText: 'State( Ex. LA )',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                  ),
                  maxLength: 2,
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
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Postal Code',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 0,
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
                  controller: _contPostalCode,
                  decoration: const InputDecoration(
                    hintText: 'Postal code',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                  ),
                  maxLength: 5,
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
          const SizedBox(height: 20.0),
          /*Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'SSN ( Social Security Number )',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 0,
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
                  keyboardType: TextInputType.number,
                  controller: _contSSN,
                  decoration: const InputDecoration(
                    hintText: 'Social Security Number',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                  ),
                  maxLength: 9,
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'BUSINESS INFO',
                  Colors.white,
                  24.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'State Of Incorporation',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 0,
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
                  controller: _contStateOfIncorporation,
                  decoration: const InputDecoration(
                    hintText: 'State Of Incorporation',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
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
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Country',
                  Colors.white,
                  14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),*/
          // _textFieldSalary(),
          //  _textFieldAddress(),
          // _textFieldPostalCode(),
          // _textFieldPEP(),
          /*Padding(
            padding: const EdgeInsets.all(16.0),
            child: textFontPOOPINS(
              //
              TEXT_FIELD_KYC,
              Colors.white,
              14.0,
            ),
          ),*/
          //  _textFieldPassport(),
          // _textFieldPassportVerification(),
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
                  // _sendRequestToCompleteProfile(context);
                  //  createCustomerInUnit(context);
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
        top: 0,
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
            readOnly: true,
            controller: _contDOB,
            decoration: const InputDecoration(
              hintText: 'DOB',
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
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                setState(() {
                  _contDOB.text = "${pickedDate.toLocal()}"
                      .split(' ')[0]; // Format the date as you like
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
