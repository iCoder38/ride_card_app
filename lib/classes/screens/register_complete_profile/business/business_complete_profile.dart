import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/screens/bottom_bar/bottom_bar.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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
  final TextEditingController _contLastName = TextEditingController();
  final TextEditingController _contEmail = TextEditingController();
  final TextEditingController _contPhone = TextEditingController();
  final TextEditingController _contPassword = TextEditingController();
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
  final TextEditingController _contEIN = TextEditingController();
  final TextEditingController _contEntityType = TextEditingController();
  final TextEditingController _contWebsite = TextEditingController();
  final TextEditingController _contAnnualRevenue = TextEditingController();
  final TextEditingController _contNumberOfEmployees = TextEditingController();
  final TextEditingController _contYearOfIncorporation =
      TextEditingController();
  final TextEditingController _contBusinessVertical = TextEditingController();
  final TextEditingController _contCashFlow = TextEditingController();
  //
  var storeSystemIPaddress = '0';
  var createdCustomerId = '';
  //
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
  final List<String> _options = [
    'LLC',
    'Partnership',
    'PubliclyTradedCorporation',
    'PrivatelyHeldCorporation',
    'NotForProfitOrganization',
  ];
  final List<String> _annualRevenueOptions = [
    'UpTo250k',
    'Between250kAnd500k',
    'Between500kAnd1m',
    'Between1mAnd5m',
    'Over5m',
  ];
  final List<String> _numberOfEmployee = [
    'UpTo10',
    'Between10And50',
    'Between50And100',
    'Between100And500',
    'Over500',
  ];
  final List<String> _cashFlow = [
    "Predictable: I'm a new company / my cash flow fluctuates",
    "Unpredictable: I'm an established company with predictable cash flows",
  ];
  final List<String> _businessVerticalOptions = [
    'AdultEntertainmentDatingOrEscortServices',
    'AgricultureForestryFishingOrHunting',
    'ArtsEntertainmentAndRecreation',
    'BusinessSupportOrBuildingServices',
    'Cannabis',
    'Construction',
    'DirectMarketingOrTelemarketing',
    'EducationalServices',
    'FinancialServicesCryptocurrency',
    'FinancialServicesDebitCollectionOrConsolidation',
    'FinancialServicesMoneyServicesBusinessOrCurrencyExchange',
    'FinancialServicesOther',
    'FinancialServicesPaydayLending',
    'GamingOrGambling',
    'HealthCareAndSocialAssistance',
    'HospitalityAccommodationOrFoodServices',
    'LegalAccountingConsultingOrComputerProgramming',
    'Manufacturing',
    'Mining',
    'Nutraceuticals',
    'PersonalCareServices',
    'PublicAdministration',
    'RealEstate',
    'ReligiousCivicAndSocialOrganizations',
    'RepairAndMaintenance',
    'RetailTrade',
    'TechnologyMediaOrTelecom',
    'TransportationOrWarehousing',
    'Utilities',
    'WholesaleTrade',
  ];
  @override
  void initState() {
    // sendBusinessApplication();
    _fetchIPAddress();
    super.initState();
  }

  Future<void> _fetchIPAddress() async {
    String? ipAddress = await getIPAddress();
    debugPrint(ipAddress);
    storeSystemIPaddress = ipAddress.toString();
  }

  @override
  void dispose() {
    _contName.dispose();
    _contLastName.dispose();
    _contEmail.dispose();
    _contPhone.dispose();
    _contPassword.dispose();
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
    _contEIN.dispose();
    _contEntityType.dispose();
    _contWebsite.dispose();
    _contAnnualRevenue.dispose();
    _contNumberOfEmployees.dispose();
    _contYearOfIncorporation.dispose();
    _contBusinessVertical.dispose();
    _contCashFlow.dispose();

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
                    hintText: 'First Name ',
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
                  'Last Name',
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
                  controller: _contLastName,
                  decoration: const InputDecoration(
                    hintText: 'Last Name ',
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
                  'Password',
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
                  controller: _contPassword,
                  decoration: const InputDecoration(
                    hintText: 'Password ',
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
                  'Phone ( business registered )',
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
                  keyboardType: TextInputType.number,
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

          //
          /*Padding(
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
          ),*/
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
          /*Padding(
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
          ),*/
          //
          // ein
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Business EIN',
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
                  controller: _contEIN,
                  decoration: const InputDecoration(
                    hintText: 'Business EIN',
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
          //
          // entity type
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Entity type',
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
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  controller: _contEntityType,
                  decoration: const InputDecoration(
                    hintText: 'Entity type',
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
                  onTap: () => _showBottomSheetEntity(context),
                ),
              ),
            ),
          ),
          //
          // annual revenue
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Annual revenue',
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
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  controller: _contAnnualRevenue,
                  decoration: const InputDecoration(
                    hintText: 'Annual revenue',
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
                  onTap: () => _showBottomSheetAnnualRevenue(context),
                ),
              ),
            ),
          ),
          //
          // annual revenue
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Number of employee',
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
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  controller: _contNumberOfEmployees,
                  decoration: const InputDecoration(
                    hintText: 'Number of employee',
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
                  onTap: () => _showBottomSheetNumberOfEmployee(context),
                ),
              ),
            ),
          ),
          //
          // year of corporation
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Year of incorporation',
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
                  controller: _contYearOfIncorporation,
                  decoration: const InputDecoration(
                    hintText: 'Year of incorporation',
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
                  maxLength: 4,
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
          // cashflow
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Cashflow',
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
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  controller: _contCashFlow,
                  decoration: const InputDecoration(
                    hintText: 'Cashflow',
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
                  onTap: () => _showBottomSheetCashflow(context),
                ),
              ),
            ),
          ),
          //
          // business vertical
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Row(
              children: [
                textFontPOOPINS(
                  'Business vertical',
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
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  controller: _contBusinessVertical,
                  decoration: const InputDecoration(
                    hintText: 'Business vertical',
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
                  onTap: () => _showBottomSheetBusinessVertical(context),
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
                  sendBusinessApplication();
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

  void _showBottomSheetBusinessVertical(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _businessVerticalOptions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_businessVerticalOptions[index]),
              onTap: () {
                setState(() {
                  _contBusinessVertical.text = _businessVerticalOptions[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showBottomSheetAnnualRevenue(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _annualRevenueOptions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_annualRevenueOptions[index]),
              onTap: () {
                setState(() {
                  _contAnnualRevenue.text = _annualRevenueOptions[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showBottomSheetCashflow(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _cashFlow.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_cashFlow[index]),
              onTap: () {
                setState(() {
                  if (index == 0) {
                    _contCashFlow.text = 'Predictable';
                  } else {
                    _contCashFlow.text = 'Unpredictable';
                  }
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showBottomSheetNumberOfEmployee(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _numberOfEmployee.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_numberOfEmployee[index]),
              onTap: () {
                setState(() {
                  _contNumberOfEmployees.text = _numberOfEmployee[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
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

  void _showBottomSheetEntity(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: _options.map((String option) {
            return ListTile(
              title: Text(option),
              onTap: () {
                setState(() {
                  _contEntityType.text = option;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
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
                  _contDOB.text = "${pickedDate.toLocal()}".split(' ')[0];
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> sendBusinessApplication() async {
    var generateUUID = const Uuid().v4();
    /*_sendRequestToCompleteProfile(generateUUID);
    return;*/

    if (storeSystemIPaddress == "0") {
      storeSystemIPaddress = "192.168.1.1";
    }

    final headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };
    final body = jsonEncode({
      "data": {
        "type": "businessApplication",
        "attributes": {
          "name": _contName.text.toString(),
          "address": {
            "street": _contAddress.text.toString(),
            "city": _contCity.text.toString(),
            "state": _contState.text.toString(),
            "postalCode": _contPostalCode.text.toString(),
            "country": COUNTRY_US,
          },
          "phone": {
            "countryCode": COUNTRY_US_PHONE_CODE,
            "number": _contPhone.text.toString(),
          },
          "stateOfIncorporation": _contState.text.toString(), // state name
          "ein": _contEIN.text.toString(), //"123456789",
          "entityType": _contEntityType.text.toString(), //"Corporation",
          // "entityType": "Corporation",
          // "ip": storeSystemIPaddress.toString(),
          "annualRevenue":
              _contAnnualRevenue.text.toString(), // "Between500kAnd1m",
          "numberOfEmployees":
              _contNumberOfEmployees.text.toString(), // "Between50And100",
          "cashFlow": _contCashFlow.text.toString(),
          "yearOfIncorporation": _contYearOfIncorporation.text.toString(),
          "countriesOfOperation": ["US", "CA"],
          // "stockSymbol": "", //"PPI",
          "businessVertical": _contBusinessVertical.text.toString(),
          "website": _contWebsite.text.toString(),
          "contact": {
            "fullName": {
              "first": _contName.text.toString(),
              "last": _contLastName.text.toString(),
            },
            "email": _contEmail.text.toString(),
            "phone": {
              "countryCode": COUNTRY_US_PHONE_CODE,
              "number": _contPhone.text.toString(),
            },
          },
          "officer": {
            "fullName": {
              "first": _contName.text.toString(),
              "last": _contLastName.text.toString(),
            },
            "dateOfBirth": _contDOB.text.toString(),
            "title": "CEO",
            "ssn": _contSSN.text.toString(),
            "email": _contEmail.text.toString(),
            "phone": {
              "countryCode": COUNTRY_US_PHONE_CODE,
              "number": _contPhone.text.toString(),
            },
            "address": {
              "street": _contAddress.text.toString(),
              "city": _contCity.text.toString(),
              "state": _contState.text.toString(),
              "postalCode": _contPostalCode.text.toString(),
              "country": COUNTRY_US,
            },
            "occupation": _contOccupation.text.toString(),
            "annualIncome": _contAnnualIncome.text,
            "sourceOfIncome": _contSourceOfIncome.text,
          },
          "beneficialOwners": [
            /*{
              "fullName": {
                "first": _contName.text.toString(),
                "last": _contLastName.text.toString(),
              },
              "dateOfBirth": _contDOB.text.toString(),
              "ssn": _contSSN.text.toString(),
              "email": _contEmail.text.toString(),
              "percentage": 50,
              "phone": {
                "countryCode": COUNTRY_US_PHONE_CODE,
                "number": _contPhone.text.toString(),
              },
              "address": {
                "street": _contAddress.text.toString(),
                "city": _contCity.text.toString(),
                "state": _contState.text.toString(),
                "postalCode": _contPostalCode.text.toString(),
                "country": COUNTRY_US,
              },
              "occupation": _contOccupation.text.toString(),
              "annualIncome": _contAnnualIncome.text,
              "sourceOfIncome": _contSourceOfIncome.text,
            }*/
          ],
          "tags": {
            "userId": generateUUID,
          },
          "idempotencyKey": generateUUID
        }
      }
    });
    if (kDebugMode) {
      print(body);
    }
    // return;

    final response = await http.post(
      Uri.parse(CREATE_APPLICATION_URL),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('===================================');
        print('Success: ${response.body}');
        print('===================================');
      }
      final jsonData = json.decode(response.body);
      if (jsonData['data']['attributes']['status'] == 'Denied') {
        //
        dismissKeyboard(context);
        Navigator.pop(context);
        customToast(
          jsonData['data']['attributes']['message'].toString(),
          Colors.redAccent,
          ToastGravity.BOTTOM,
        );
        return;
      } else if (jsonData['data']['attributes']['status'] ==
          'AwaitingDocuments') {
        debugPrint('======> AWAITED DOCUMENTS <=======');
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
        _sendRequestToCompleteProfile(generateUUID.toString());
      } else {
        debugPrint('======> APPROVED <=======');
        // if (kDebugMode) {
        //   print('CUSTOMER ID ==> $createdCustomerId');
        // }
        createdCustomerId = jsonData['data']['relationships']['customer']
                ['data']['id']
            .toString();
        _sendRequestToCompleteProfile(generateUUID.toString());
      }
    } else {
      if (kDebugMode) {
        print('Failed: ${response.body}');
      }
      Navigator.pop(context);
      customToast(
        'Something went wrong with your details. Please check again',
        Colors.redAccent,
        ToastGravity.TOP,
      );
    }
  }

  // API
  void _sendRequestToCompleteProfile(
    String uuid,
  ) async {
    debugPrint(
        '===============================================================');
    debugPrint(
        '============= API: COMPLETE PROFILE ===========================');

    // var box = await Hive.openBox<MyData>('myBox1');
    // var myData = box.getAt(0);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString('key_save_token_locally'));
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    // SharedPreferences prefs2 = await SharedPreferences.getInstance();
    // prefs2.setString('Key_save_login_user_id', widget.userId);

    final parameters = {
      'action': 'registration',
      // 'userId': widget.userId,
      'fullName': _contName.text.toString(),
      'lastName': _contLastName.text.toString(),
      'email': _contEmail.text.toString(),
      'contactNumber': _contPhone.text.toString(),
      'password': _contPassword.text.toString(),
      'role': 'Business',
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
      'key_data': uuid,
      'firebaseId': '',
      'customerId': createdCustomerId,
      // business profile
      'businessState': _contState.text.toString(),
      'businessYear': _contYearOfIncorporation.text.toString(),
      'businessType': _contEntityType.text.toString(),
      'businessIP': storeSystemIPaddress.toString(),
      'businessRevenue': _contAnnualRevenue.text.toString(),
      'businessEmployees': _contNumberOfEmployees.text.toString(),
      'businessCashflow': _contCashFlow.text.toString(),
      'businessyear2': _contEIN.text.toString(),
      'businessVertical': _contBusinessVertical.text.toString(),
      'businessWebsite': _contWebsite.text.toString(),
    };
    if (kDebugMode) {
      print(parameters);
    }
    // await box.close();

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
        if (successStatus.toLowerCase() == 'success'.toLowerCase()) {
          SharedPreferences prefs2 = await SharedPreferences.getInstance();
          prefs2.setString('Key_save_login_user_id',
              jsonResponse['data']['userId'].toString());
          // save user role

          prefs2.setString(
            'key_save_user_role',
            jsonResponse['data']['role'].toString(),
          );

          debugPrint('SUCCESS');
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
        } else {
          customToast(
            successMessage,
            hexToColor(appREDcolorHexCode),
            ToastGravity.TOP,
          );
          /*String status = jsonResponse['data']['attributes']['status'];
          String message = jsonResponse['data']['attributes']['message'];
          print('Status: $status');
          print('Message: $message');*/
        }

        // }
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
            email: _contEmail.text.toString(),
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
    var mergeName =
        '${_contName.text.toString()} ${_contLastName.text.toString()}';
    debugPrint(mergeName);
    await FirebaseAuth.instance.currentUser!
        .updateDisplayName(mergeName)
        .then((v) {
      debugPrint('REGISTERED NAME ALSO');
      // _sendRequestToCompleteProfile();
    });
  }

  successfullyCreatedAccount(status, message) {
    //
    customToast(message, Colors.green, ToastGravity.BOTTOM);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomBar(selectedIndex: 0)),
    );
  }
}
