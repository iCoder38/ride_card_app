import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:ride_card_app/classes/SquareAPIs/repositories/repositories.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/hive/hive.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/screens/bottom_bar/bottom_bar.dart';
// import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';
// import 'package:ride_card_app/classes/screens/register_complete_profile_business/register_complete_profile_business.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen(
      {super.key,
      required this.getFirstName,
      required this.getLastName,
      required this.getContactNumber,
      required this.getEmail,
      required this.userId});

  final String getFirstName;
  final String getLastName;
  final String getContactNumber;
  final String getEmail;
  final String userId;

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  //
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  final _formKey = GlobalKey<FormState>();
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
  // final TextEditingController _contPEP = TextEditingController();
  // final TextEditingController _contPassport = TextEditingController();
  // final TextEditingController _contPassportVerification = TextEditingController()

  var createdCustomerId = '';

  var UUID_KEY_FOR_REGISTRATION;
  final _email = '';

  final List<String> occupations = [
    "ArchitectOrEngineer",
    "BusinessAnalystAccountantOrFinancialAdvisor",
    "CommunityAndSocialServicesWorker",
    "ConstructionMechanicOrMaintenanceWorker",
    "Doctor",
    "Educator",
    "EntertainmentSportsArtsOrMedia",
    "ExecutiveOrManager",
    "FarmerFishermanForester",
    "FoodServiceWorker",
    "GigWorker",
    "HospitalityOfficeOrAdministrativeSupportWorker",
    "HouseholdManager",
    "JanitorHousekeeperLandscaper",
    "Lawyer",
    "ManufacturingOrProductionWorker",
    "MilitaryOrPublicSafety",
    "NurseHealthcareTechnicianOrHealthcareSupport",
    "PersonalCareOrServiceWorker",
    "PilotDriverOperator",
    "SalesRepresentativeBrokerAgent",
    "ScientistOrTechnologist",
    "Student",
  ];
  final List<String> _incomeSources = [
    'EmploymentOrPayrollIncome',
    'PartTimeOrContractorIncome',
    'InheritancesAndGifts',
    'PersonalInvestments',
    'BusinessOwnershipInterests',
    'GovernmentBenefits'
  ];
  final List<String> _annualIncome = [
    'UpTo10k',
    'Between10kAnd25k',
    'Between25kAnd50k',
    'Between50kAnd100k',
    'Between100kAnd250k',
    'Over250k'
  ];
  @override
  void initState() {
    // createAnAccountInFirebaseFirst(context);
    super.initState();
  }

  @override
  void dispose() {
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
          const SizedBox(
            height: 20.0,
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
          _textFieldOccupation(),
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
          _textFieldAnnualIncome(),
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
          _textFieldSourceOfIncome(),
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
          Padding(
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
                  createCustomerInUnit(context);
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

  Padding _textFieldAnnualIncome() {
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
            controller: _contAnnualIncome,
            decoration: const InputDecoration(
              hintText: 'Annual Income',
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
            onTap: () {
              _showAnnualIncomePicker(context);
            },
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

  void _showAnnualIncomePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _annualIncome.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_annualIncome[index]),
              onTap: () {
                setState(() {
                  _contAnnualIncome.text = _annualIncome[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showOccupationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: occupations.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(occupations[index]),
              onTap: () {
                setState(() {
                  _contOccupation.text = occupations[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showIncomeSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _incomeSources.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_incomeSources[index]),
              onTap: () {
                setState(() {
                  _contSourceOfIncome.text = _incomeSources[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  Padding _textFieldOccupation() {
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
            controller: _contOccupation,
            decoration: const InputDecoration(
              hintText: 'Occupation',
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
            onTap: () {
              _showOccupationPicker(context);
            },
            readOnly: true, // Make the TextFormField read-only
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

  Padding _textFieldSourceOfIncome() {
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
            controller: _contSourceOfIncome,
            decoration: const InputDecoration(
              hintText: 'Source of Income',
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
            onTap: () => _showIncomeSourceOptions(context),
            readOnly: true, // Make the TextFormField read-only
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
              DateTime eighteenYearsAgo =
                  DateTime.now().subtract(const Duration(days: 365 * 19));

              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: eighteenYearsAgo,
                firstDate: DateTime(1900),
                lastDate: eighteenYearsAgo,
              );

              if (pickedDate != null) {
                setState(() {
                  _contDOB.text = "${pickedDate.toLocal()}".split(' ')[0];
                });
              }

              /*DateTime? pickedDate = await showDatePicker(
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
              }*/
            },
          ),
        ),
      ),
    );
  }

  /*Padding _textFieldPassportVerification() {
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
  }*/

  /*Padding _textFieldPassport() {
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
  }*/

  /*Padding _textFieldPEP() {
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
  }*/

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

  Future<void> deleteAuthUser(status) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      // Get the current user
      User? user = auth.currentUser;

      // Delete the user
      await user?.delete().then((v) {
        //
        Navigator.pop(context);
        customToast(status, hexToColor(appREDcolorHexCode), ToastGravity.TOP);
      });

      // User deleted.
    } catch (e) {
      // An error occurred. Handle it accordingly.
      if (kDebugMode) {
        print("Error deleting user: $e");
      }
    }
  }

//

  // CREATE ACCOUNT IN UNIT
  Future<void> createCustomerInUnit(context) async {
    logger.d('============= UNIT ===========================');
    UUID_KEY_FOR_REGISTRATION = const Uuid().v4();
    //
    String baseUrl = CREATE_APPLICATION_URL;

    final Uri url = Uri.parse(baseUrl);

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    Map<String, dynamic> body = {
      "data": {
        "type": "individualApplication",
        "attributes": {
          // "passport":"U156243",
          "ssn": _contSSN.text.toString(),
          "fullName": {
            "first": widget.getFirstName.toString(),
            "last": widget.getLastName.toString(),
          },
          "dateOfBirth": _contDOB.text.toString(),
          "address": {
            "street": _contAddress.text.toString(),
            "city": _contCity.text.toString(),
            "state": _contState.text.toString(),
            "postalCode": _contPostalCode.text.toString(),
            "country": COUNTRY_US,
          },
          "email": widget.getEmail.toString(),
          "annualIncome": _contAnnualIncome.text,
          "sourceOfIncome": _contSourceOfIncome.text,
          "phone": {
            "countryCode": COUNTRY_US_PHONE_CODE,
            "number": widget.getContactNumber.toString(),
          },
          "occupation": _contOccupation.text.toString(),
          "tags": {
            "test": "webhook-tag",
            "key": "another-tag",
            "number": "111"
          },
          "idempotencyKey": UUID_KEY_FOR_REGISTRATION,
        },
      }
    };
    if (kDebugMode) {
      print(body);
    }
    logger.d(widget.getEmail.toString());

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (kDebugMode) {
        print('*******************************');
        print(response.statusCode);
        print(response.body);
        print('********************************');
      }
      if (response.statusCode == 201) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);
        // print(jsonData['data']);
        // print(jsonData['data']['attributes']['status']);

        /*if (kDebugMode) {
          print('=================== S');
          print(jsonData);
          print('===================');
        }*/
        //
        // var decodedData = json.decode(jsonData);
        //  var attributes = jsonData['data']['attributes'];
        // String status = attributes['status'];
        // String message = attributes['message'];
        //

        if (jsonData['data']['attributes']['status'] == 'Denied') {
          //
          dismissKeyboard(context);
          customToast(
            'This account and Email is blocked by Ride Card App. Due to unusual activity. Please contact support.',
            Colors.redAccent,
            ToastGravity.BOTTOM,
          );
          return;
        } else if (jsonData['data']['attributes']['status'] ==
            'AwaitingDocuments') {
          logger.d('======> AWAITED DOCUMENTS <=======');
          //
          createdCustomerId = jsonData['included'][0]['id'].toString();
          if (kDebugMode) {
            print('CUSTOMER ID ==> $createdCustomerId');
          }
          customToast(
            'You Id has been created but your document is not verified. Please contact support and upload your documents.',
            Colors.redAccent,
            ToastGravity.BOTTOM,
          );
          // createCustomerInSquare(UUID_KEY_FOR_REGISTRATION);
          _sendRequestToCompleteProfile(UUID_KEY_FOR_REGISTRATION);
        } else {
          debugPrint('======> APPROVED <=======');
          // if (kDebugMode) {
          //   print('CUSTOMER ID ==> $createdCustomerId');
          // }
          createdCustomerId = jsonData['data']['relationships']['customer']
                  ['data']['id']
              .toString();
          // _sendRequestToCompleteProfile();
          // createCustomerInSquare(UUID_KEY_FOR_REGISTRATION);
          _sendRequestToCompleteProfile(UUID_KEY_FOR_REGISTRATION);
        }

        //
      } else if (response.statusCode == 400) {
        dismissKeyboard(context);
        Navigator.pop(context);
        customToast(
          'This details is already exists.',
          Colors.orange,
          ToastGravity.BOTTOM,
        );
      } else {
        final jsonData = json.decode(response.body);
        debugPrint('=================== E');
        if (kDebugMode) {
          print(jsonData);
          debugPrint('===================');
        }
        // Navigator.pop(context);
        customToast(
          'Something wrong. Please check you data and try again.',
          Colors.redAccent,
          ToastGravity.TOP,
        );

        // If the server returns an error response, throw an exception
        throw Exception('Failed to update data');
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
      Navigator.pop(context);
      customToast(
        'Something wrong. Server issue.',
        Colors.redAccent,
        ToastGravity.TOP,
      );
    }
  }

  /*createCustomerInSquare(generateUUID) async {
    debugPrint('=============================================');
    debugPrint('======== SQUARE CUSTOMER ==============');
    debugPrint('=============================================');

    final SquareRepository squareRepository = SquareRepository();

    try {
      final customer = await squareRepository.addCustomer(
        birthday: _contDOB.text.toString(),
        emailAddress: widget.getEmail.toString(),
        familyName: widget.getLastName.toString(),
        idempotencyKey: generateUUID,
        givenName: widget.getFirstName.toString(),
      );
      if (kDebugMode) {
        print('Customer created: $customer');
      }
      _sendRequestToCompleteProfile(customer['id'].toString());
    } catch (error) {
      if (kDebugMode) {
        print('Failed to create customer: $error');
      }
      Navigator.pop(context);
      customToast(error.toString(), Colors.redAccent, ToastGravity.TOP);
    }

    /*final SquareRepository squareRepository = SquareRepository();

    try {
      final customer = await squareRepository.addCustomer(
        idempotencyKey: generateUUID,
        givenName: widget.getFirstName.toString(),
        familyName: widget.getLastName.toString(),
        emailAddress: widget.getEmail.toString(),
        birthday: _contDOB.text.toString(),
      );
      if (kDebugMode) {
        print('Customer created: $customer');
      }
      _sendRequestToCompleteProfile();
    } catch (error) {
      if (kDebugMode) {
        print('Failed to create customer: $error');
      }
      Navigator.pop(context);
      customToast(error.toString(), Colors.redAccent, ToastGravity.TOP);
    }*/
    /*final SquareRepository squareRepository = SquareRepository();

    try {
      final customer = await squareRepository.addCustomer(
        givenName: "Amelia",
        familyName: "Earhart",
        emailAddress: "Amelia.Earhart@example.com",
        addressLine1: "500 Electric Ave",
        addressLine2: "Suite 600",
        locality: "New York",
        adminDistrict: "NY",
        postalCode: "10003",
        country: "US",
        phoneNumber: "+1-212-555-4240",
        referenceId: "YOUR_REFERENCE_ID",
        note: "a customer",
      );
      print('Customer created: $customer');
    } catch (error) {
      print('Failed to create customer: $error');
    }*/
  }*/

  // API
  void _sendRequestToCompleteProfile(String squareCustomerId) async {
    debugPrint('=============================================');
    debugPrint('======== API: COMPLETE PROFILE ==============');
    debugPrint('=============================================');

    var box = await Hive.openBox<MyData>('myBox1');
    // var myData = box.getAt(0);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString('key_save_token_locally'));
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    prefs2.setString('Key_save_login_user_id', widget.userId);

    final parameters = {
      'action': 'editProfile',
      'userId': widget.userId,
      'City': _contCity.text.toString(),
      'zipcode': _contPostalCode.text.toString(),
      'country': COUNTRY_US,
      'state': _contState.text.toString(),
      'ssn': _contSSN.text.toString(),
      'dob': _contDOB.text.toString(),
      'Salary': _contAnnualIncome.text.toString(),
      'PlaceOfWork': _contSourceOfIncome.text.toString(),
      'address': _contAddress.text.toString(),
      'occupation': _contOccupation.text.toString(),
      'key_data': squareCustomerId,
      'firebaseId': '', //squareCustomerId.toString(),
      'customerId': createdCustomerId,
    };
    if (kDebugMode) {
      print(parameters);
    }
    await box.close();

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
          debugPrint('NOT AUTHORIZE');
          apiServiceGT
              .generateToken(
            widget.userId,
            widget.getEmail.toString(),
            'Member',
          )
              .then((v) {
            //
            /*if (kDebugMode) {
              print('TOKEN ==> $v');
            }*/
            // again click
            _sendRequestToCompleteProfile(squareCustomerId);
          });
        } else {
          //
          createAnAccountInFirebase();
          // createAnAccountInFirebaseFirst(context);
          successStatus.toLowerCase() == 'success'
              ? successfullyCreatedAccount(successStatus, successMessage)
              : Navigator.pop(context);
          customToast(
            successStatus,
            hexToColor(appREDcolorHexCode),
            ToastGravity.TOP,
          );
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

// REGISTER THIS USER IN FIREBASE NOW
  createAnAccountInFirebase() async {
    //
    debugPrint('==================================================');
    debugPrint('============= FIREBASE ===========================');
    // showLoadingUI(context, PLEASE_WAIT);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: widget.getEmail.toString(),
            password: 'firebase_password_rca_!',
          )
          .then((value) => {
                //
                // debugPrint('REGISTERED IN FIREBASE'),
                updateUserName(context)
                //
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        /*Navigator.pop(context);
        customToast(
          'The password provided is too weak.',
          Colors.redAccent,
          ToastGravity.TOP,
        );*/
      } else if (e.code == 'email-already-in-use') {
        /*Navigator.pop(context);
        FocusScope.of(context).unfocus();
        customToast(
          //
          TEXT_ALREADY_BEEN_EXIST,
          hexToColor(appREDcolorHexCode),
          ToastGravity.TOP,
        );*/
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

  updateUserName(context) async {
    var mergeName = '${widget.getFirstName} ${widget.getLastName}';
    debugPrint(mergeName);
    await FirebaseAuth.instance.currentUser!
        .updateDisplayName(mergeName)
        .then((v) {
      debugPrint('REGISTERED NAME ALSO');
      // _sendRequestToCompleteProfile();
    });
  }

  successfullyCreatedAccount(status, message) {
    customToast(message, Colors.green, ToastGravity.BOTTOM);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BottomBar(
          selectedIndex: 0,
        ),
      ),
    );*/
  }
}
