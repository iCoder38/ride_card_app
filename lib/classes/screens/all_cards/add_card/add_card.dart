import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/stripe/generate_token/generate_token.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/sheet/alreadySavedCardSheet.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/get_price.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/model/model.dart';
import 'package:ride_card_app/classes/screens/convenience_fee/convenience_fees.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key, required this.strMenuBack});

  final String strMenuBack;

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  //
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contCardHolderName = TextEditingController();
  final TextEditingController _contCardNumber = TextEditingController();
  final TextEditingController _contCardExpYear = TextEditingController();
  final TextEditingController _contCardExpMonth = TextEditingController();
  //
  var feesAndTaxesAmount = 0;
  var strFeesType = '';
  var storeStripeCustomerId = '';
  //
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
        child: _UIAfterBGKit(context),
      ),
    );
  }

  Widget _UIAfterBGKit(context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 80),
          widget.strMenuBack == 'yes'
              ? Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, 'reload_screen');
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 16.0,
                          ),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: hexToColor(appORANGEcolorHexCode),
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40.0,
                    ),
                    Container(
                      height: 40,
                      color: Colors.transparent,
                      child: Center(
                        child: textFontORBITRON(
                          //
                          'Add card',
                          Colors.white,
                          18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                )
              : customNavigationBarForMenu('Add card', _scaffoldKey),
          const SizedBox(height: 20),
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
                  controller: _contCardHolderName,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Card holder name',
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              // top: 10.0,
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
                  controller: _contCardNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Card number',
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10.0,
                    ).copyWith(
                      // Adjust the top padding to center the hint text vertically
                      top: 14.0,
                    ),
                  ),
                  maxLength: 16,
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
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 8.0,
                    // top: 10.0,
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
                        controller: _contCardExpMonth,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Exp. Month',
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 10.0,
                          ).copyWith(
                            // Adjust the top padding to center the hint text vertically
                            top: 14.0,
                          ),
                        ),
                        maxLength: 2,
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
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 16.0,
                    // top: 10.0,
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
                        controller: _contCardExpYear,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Exp. Year',
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 10.0,
                          ).copyWith(
                            // Adjust the top padding to center the hint text vertically
                            top: 14.0,
                          ),
                        ),
                        maxLength: 2,
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
              ),
            ],
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
                  // showLoadingUI(context, 'adding...');
                  //
                  // s
                  /*pushToConvenienceFeeScreen(
                    context,
                    'Add external card',
                    'addExternalDebitCard',
                  );*/
                  strFeesType = 'addExternalDebitCard';
                  fetchProfileData();
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
                    'Add',
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

  // API
  void _addCardInEvsServer(context) async {
    // debugPrint('API ==> ADD CARD');
    showLoadingUI(context, 'please wait...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {
      'action': 'cardadd',
      'userId': userId,
      'cardNumber': _contCardNumber.text.toString(),
      'nameOnCard': _contCardHolderName.text.toString(),
      'Expiry_Month': _contCardExpMonth.text.toString(),
      'Expiry_Year': _contCardExpYear.text.toString(),
      'cardType': 'Debit Card'.toString(),
      // unit
      'card_group': '1',
      'unit_card_id': '',
      'bank_id': '',
      'bank_number': '',
      'relationship_card_type': '',
      'customerID': '',
      'status': '1' // 1 = add , 0 = remove
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
            _addCardInEvsServer(context);
          });
        } else {
          //
          _contCardHolderName.text = '';
          _contCardNumber.text = '';
          _contCardExpMonth.text = '';
          _contCardExpYear.text = '';
          //
          successStatus.toLowerCase() == 'success'
              ? successfullyCreatedAccount(successStatus, successMessage)
              : Navigator.pop(context);
        }
      } else {
        customToast(
          successStatus,
          Colors.redAccent,
          ToastGravity.TOP,
        );
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  successfullyCreatedAccount(status, message) {
    //
    customToast(message, Colors.green, ToastGravity.TOP);
    Navigator.pop(context);
  }

  Future<void> fetchProfileData() async {
    showLoadingUI(context, 'Please wait...');
    await sendRequestToProfileDynamic().then((v) {
      if (kDebugMode) {
        print('=====================================');
        print('Stripe Mode is: ====> $STRIPE_STATUS');
        print('=====================================');
      }

      if (STRIPE_STATUS == 'T') {
        storeStripeCustomerId = v['data']['stripe_customer_id_Test'];
      } else {
        storeStripeCustomerId = v['data']['stripe_customer_id_Live'];
      }
      // logger.d(v);
      logger.d(storeStripeCustomerId);

      if (storeStripeCustomerId == '') {
        debugPrint('There is no stripe customer key created');
      }

      // Logger().d(storeStripeToken);
      // Logger().d(v);
    });
    getFeesAndTaxes();
  }

  void getFeesAndTaxes() async {
    ApiServiceToGetFeesAndTaxes apiService = ApiServiceToGetFeesAndTaxes();

    List<FeeData>? feeList = await apiService.fetchFeesAndTaxes();

    if (feeList != null) {
      for (var fee in feeList) {
        if (kDebugMode) {
          print(
            'ID: ${fee.id}, Name: ${fee.name}, Type: ${fee.type}, Amount: ${fee.amount}',
          );
        }
        if (strFeesType == fee.name) {
          debugPrint('===================');
          debugPrint('Yes, fee type found');
          debugPrint('===================');
          feesAndTaxesAmount = int.parse(fee.amount.toString());
        } else {
          debugPrint('===================');
          debugPrint('No, fee type found');
          debugPrint('===================');
          feesAndTaxesAmount = 0;
        }
        /*if (fee.name == widget.feeType) {
          if (fee.type == TAX_TYPE_PERCENTAGE) {
            feesAndTaxesType = fee.type.toString();
            feesAndTaxesAmount = double.parse(fee.amount.toString());
            showConvenienceFeesOnPopup = (feesAndTaxesAmount * 10) / 100;
            totalAmountAfterCalculateFee = (feesAndTaxesAmount * 10) / 100;
          } else {
            debugPrint(fee.type);
            feesAndTaxesType = fee.type.toString();
            feesAndTaxesAmount = double.parse(fee.amount.toString());
            showConvenienceFeesOnPopup = feesAndTaxesAmount;
            totalAmountAfterCalculateFee = feesAndTaxesAmount;
          }
        }*/
      }
      debugPrint('===================');
      debugPrint('Fee amount is: ====> $feesAndTaxesAmount');
      debugPrint('===================');
      if (feesAndTaxesAmount == 0) {
        debugPrint('====================================');
        debugPrint('===== BY PASS WITHOUT CONV FEE =====');
        debugPrint('====================================');
        validateCard();
      } else {
        debugPrint('====================================');
        debugPrint('======= DEDUCT CONV FEE ============');
        debugPrint('====================================');
        validateCard();
      }
      /*if (feesAndTaxesType == TAX_TYPE_PERCENTAGE) {
        String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
        showConvenienceFeesOnPopup = double.parse(formattedValue.toString());
        // FEES CALCULATOR
        calculateFeesAndReturnValue();
      } else {
        String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
        showConvenienceFeesOnPopup = double.parse(formattedValue.toString());
        fetchAndCheckSavedCard(context);
      }*/
    } else {
      if (kDebugMode) {
        print('Failed to retrieve fee data.');
      }
    }
  }

  validateCard() {
    if (_contCardHolderName.text == '') {
      exceptionAlert('Name');
      return;
    }
    if (_contCardNumber.text == '') {
      exceptionAlert('Number');
      return;
    }
    if (_contCardExpMonth.text == '') {
      exceptionAlert('Month');
      return;
    }
    if (_contCardExpYear.text == '') {
      exceptionAlert('Year');
      return;
    } else {
      debugPrint('===============================================');
      debugPrint('======= CARD VALIDATE SUCCESSFULLY ============');
      debugPrint('===============================================');
      final cardDetails = SavedCardDetails(
        cardNumber: _contCardNumber.text.toString(),
        cardholderName: _contCardHolderName.text,
        expMonth: _contCardExpMonth.text.toString(),
        expYear: _contCardExpYear.text.toString(),
        cvv: '123'.toString(),
      );
      if (kDebugMode) {
        print(cardDetails.cardNumber);
        print(_contCardHolderName.text);
        print(cardDetails.expMonth);
        print(cardDetails.expYear);
        print(cardDetails.cvv);
      }
      //
      if (storeStripeCustomerId == '') {
        debugPrint('There is no stripe customer key created');
        // _registerCustomerInStripe(
        //   number,
        //   month,
        //   year,
        //   cvv,
        // );
        handleStripeTokenCreation(cardDetails);
        /*final newStripeToken = createStripeToken(
          cardNumber: cardDetails.cardNumber,
          expMonth: cardDetails.expMonth,
          expYear: cardDetails.expYear,
          cvc: cardDetails.cvv,
        ).then((v) {
          if (v == false) {}
        });

        if (newStripeToken['success:'] == '') {}*/

        // Use the token for further processing, such as making a payment
        // if (kDebugMode) {
        //   print(newStripeToken);
        // }
      }
    }
  }

  void handleStripeTokenCreation(cardDetails) async {
    final result = await createStripeToken(
      cardNumber: cardDetails.cardNumber,
      expMonth: cardDetails.expMonth,
      expYear: cardDetails.expYear,
      cvc: cardDetails.cvv,
    );

    if (result['success'] == true) {
      if (kDebugMode) {
        print('Token ID: ${result['tokenId']}');
      }
    } else {
      if (kDebugMode) {
        print('Error: ${result['message']}');
      }
      Navigator.pop(context);
      dismissKeyboard(context);
      customToast(
        result['message'],
        Colors.redAccent,
        ToastGravity.BOTTOM,
      );
    }
  }

  exceptionAlert(String title) {
    dismissKeyboard(context);
    Navigator.pop(context);
    customToast(
      '$title should not be empty',
      Colors.redAccent,
      ToastGravity.BOTTOM,
    );
  }

  Future<void> pushToConvenienceFeeScreen(
    BuildContext context,
    String title,
    String feeType,
  ) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConvenienceFeesChargesScreen(
          title: title, //'Close my account',
          feeType: feeType, // 'accountClosingFee',
        ),
      ),
    );

    if (!mounted) return;
    //
    if (result == REFRESH_CONVENIENCE_FEES) {
      if (kDebugMode) {
        print(result);
        print(feeType);
      }
      _addCardInEvsServer(context);
    }
  }
}
