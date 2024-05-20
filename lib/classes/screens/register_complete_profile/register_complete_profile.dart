import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/register_complete_profile_business/register_complete_profile_business.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  //
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
            height: 80.0,
          ),
          customNavigationBar(TEXT_NAVIGATION_TITLE_COMPLETE_PROFILE),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CompleteProfileBusinessScreen()),
                  );
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
}
