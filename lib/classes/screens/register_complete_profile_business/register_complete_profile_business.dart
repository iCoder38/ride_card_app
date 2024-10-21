import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';

class CompleteProfileBusinessScreen extends StatefulWidget {
  const CompleteProfileBusinessScreen({super.key});

  @override
  State<CompleteProfileBusinessScreen> createState() =>
      _CompleteProfileBusinessScreenState();
}

class _CompleteProfileBusinessScreenState
    extends State<CompleteProfileBusinessScreen> {
  //
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contAddress = TextEditingController();
  final TextEditingController _contCity = TextEditingController();
  final TextEditingController _contPostalCode = TextEditingController();
  final TextEditingController _contCountry = TextEditingController();
  final TextEditingController _contTaxId = TextEditingController();
  final TextEditingController _contRegisteredName = TextEditingController();
  final TextEditingController _contRegistrationNumber = TextEditingController();
  final TextEditingController _contDescriptionOfYourbusiness =
      TextEditingController();
  //
  @override
  void dispose() {
    _contAddress.dispose();
    _contCity.dispose();
    _contPostalCode.dispose();
    _contCountry.dispose();
    _contTaxId.dispose();
    _contRegisteredName.dispose();
    _contRegistrationNumber.dispose();
    _contDescriptionOfYourbusiness.dispose();

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
        child: _UIKitCompleteProfileBusinessAfterBG(context),
      ),
    );
  }

  Widget _UIKitCompleteProfileBusinessAfterBG(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //
          const SizedBox(
            height: 80.0,
          ),
          customNavigationBar(context, TEXT_NAVIGATION_TITLE_COMPLETE_PROFILE),
          //
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
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10.0),
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10.0),
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
            padding: const EdgeInsets.all(16.0),
            child: textFontPOOPINS(
              //
              'Document details',
              Colors.white,
              14.0,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: Center(
                child: TextFormField(
                  controller: _contTaxId,
                  decoration: const InputDecoration(
                    hintText: 'Tax ID',
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
                  controller: _contRegisteredName,
                  decoration: const InputDecoration(
                    hintText: 'Registered Name',
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
                  controller: _contRegistrationNumber,
                  decoration: const InputDecoration(
                    hintText: 'Registration number',
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
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: Center(
                child: TextFormField(
                  controller: _contDescriptionOfYourbusiness,
                  decoration: const InputDecoration(
                    hintText: 'Description of your business',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
                    ),
                  ),
                  style: GoogleFonts.poppins(fontSize: 14.0),
                  maxLines: 4,
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
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset(
                      'assets/images/check.png',
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: textFontPOOPINS(
                      //
                      TEXT_ACCEPT_TERMS,
                      Colors.white,
                      12.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
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
                    'Complete profile',
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
}
