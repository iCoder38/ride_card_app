import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/show_complete_profile/model/model.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';

class ShowCompleteProfileUserScreen extends StatefulWidget {
  const ShowCompleteProfileUserScreen({super.key});

  @override
  State<ShowCompleteProfileUserScreen> createState() =>
      _ShowCompleteProfileUserScreenState();
}

class _ShowCompleteProfileUserScreenState
    extends State<ShowCompleteProfileUserScreen> {
  //
  final TextEditingController _contDOB = TextEditingController();

  final TextEditingController _contAnnualIncome = TextEditingController();
  final TextEditingController _contSourceOfIncome = TextEditingController();
  final TextEditingController _contOccupation = TextEditingController();
  final TextEditingController _contAddress = TextEditingController();

  final TextEditingController _contCity = TextEditingController();
  final TextEditingController _contState = TextEditingController();
  final TextEditingController _contPostalCode = TextEditingController();

  late UserData _userData;

  final TextEditingController _contSSN = TextEditingController();
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
      if (kDebugMode) {
        print(myFullData);
      }
      //
      parseAllValue();
    });
    // print(responseBody);
  }

  parseAllValue() {
    //
    _contDOB.text = myFullData['data']['dob'];
    _contOccupation.text = myFullData['data']['occupation'] ?? '';
    _contAnnualIncome.text = myFullData['data']['Salary'] ?? '';
    _contSourceOfIncome.text = myFullData['data']['PlaceOfWork'] ?? '';
    _contAddress.text = myFullData['data']['address'] ?? ''; // street
    _contCity.text = myFullData['data']['City'] ?? '';
    _contState.text = myFullData['data']['state'] ?? '';
    _contPostalCode.text = myFullData['data']['zipcode'] ?? '';
    _contSSN.text = myFullData['data']['ssn'] ?? '';
    setState(() {});
  }

  void _initializeData() {
    final myFullDataModelParse = {
      'data': {
        'dob': myFullData['data']['dob'],
        'occupation': myFullData['data']['occupation'] ?? '',
        'Salary': myFullData['data']['Salary'] ?? '',
        'PlaceOfWork': myFullData['data']['PlaceOfWork'] ?? '',
        'address': myFullData['data']['address'] ?? '', // street
        'City': myFullData['data']['City'] ?? '',
        'state': myFullData['data']['state'] ?? '',
        'zipcode': myFullData['data']['zipcode'] ?? '',
        'ssn': myFullData['data']['ssn'] ?? '',
      },
    };

    setState(() {
      _userData = UserData.fromMap(myFullDataModelParse['data']!);
    });
  }

  @override
  Widget build(BuildContext context) {
    //
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
      // key: _formKey,
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
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
            // onTap: () async {
            //   DateTime? pickedDate = await showDatePicker(
            //     context: context,
            //     initialDate: DateTime.now(),
            //     firstDate: DateTime(1900),
            //     lastDate: DateTime.now(),
            //   );

            //   if (pickedDate != null) {
            //     setState(() {
            //       _contDOB.text = "${pickedDate.toLocal()}"
            //           .split(' ')[0]; // Format the date as you like
            //     });
            //   }
            // },
          ),
        ),
      ),
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
}
