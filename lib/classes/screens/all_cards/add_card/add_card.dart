import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/stripe/generate_token/generate_token.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/sheet/alreadySavedCardSheet.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/get_price.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/model/model.dart';
import 'package:ride_card_app/classes/screens/convenience_fee/convenience_fees.dart';
import 'package:ride_card_app/classes/service/charge_money_from_stripe/charge_money_from_stripe.dart';
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
  final ApiService _apiService2 = ApiService();
  final GenerateTokenService _apiServiceGT = GenerateTokenService();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  final stripeService = ChargeMoneyStripeService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contCardHolderName = TextEditingController();
  final TextEditingController _contCardNumber = TextEditingController();
  final TextEditingController _contCardExpYear = TextEditingController();
  final TextEditingController _contCardExpMonth = TextEditingController();
  final TextEditingController _contCVV = TextEditingController();
  //
  var feesAndTaxesAmount = 0.0;
  var strFeesType = '';
  var storeStripeCustomerId = '';
  var storeStripeToken = '';
  bool isByPass = false;
  var storeCustomerId = '';
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
                        controller: _contCVV,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'CVV',
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
                        maxLength: 3,
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
    //  showLoadingUI(context, 'please wait...');
    /*customToast(
      '10: add card',
      Colors.red,
      ToastGravity.BOTTOM,
    );*/
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
    // return;

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
          _contCVV.text = '';
          //

          successStatus.toLowerCase() == 'success'
              ? createStripeCustomerAccount(storeStripeCustomerId)
              // successfullyCreatedAccount(successStatus, successMessage)
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
        print('Stripe Mode is: ====> $v');
        print('=====================================');
      }
      if (v == null) {
        dismissKeyboard(context);
        Navigator.pop(context);
        customToast(
          'Something went wrong. Please try after sometime.',
          Colors.red,
          ToastGravity.BOTTOM,
        );
        return;
      }
      dismissKeyboard(context);
      /*customToast(
        '1: Init',
        Colors.red,
        ToastGravity.BOTTOM,
      );*/

      // storeCustomerId = v['data']['customerId'];

      if (STRIPE_STATUS == 'T') {
        storeStripeCustomerId = v['data']['stripe_customer_id_Test'];
      } else {
        storeStripeCustomerId = v['data']['stripe_customer_id_Live'];
      }
      /*customToast(
        '2: Start',
        Colors.red,
        ToastGravity.BOTTOM,
      );*/
      // logger.d('Stripe customer id: ==> $storeStripeCustomerId');

      if (storeStripeCustomerId == '') {
        /*if (kDebugMode) {
          print('=============================================');
          debugPrint('There is no stripe customer key created');
          print('=============================================');
        }*/
        // getFeesAndTaxes();
        Navigator.pop(context);
        customToast(
          'Account key is invalid. Please try again after sometime.',
          Colors.red,
          ToastGravity.BOTTOM,
        );
      } else {
        /*customToast(
          '3:tax',
          Colors.red,
          ToastGravity.BOTTOM,
        );*/
        getFeesAndTaxes();
      }
    });
  }

  void getFeesAndTaxes() async {
    ApiServiceToGetFeesAndTaxes apiService = ApiServiceToGetFeesAndTaxes();

    List<FeeData>? feeList = await apiService.fetchFeesAndTaxes();
    /*customToast(
      '4: get fees',
      Colors.red,
      ToastGravity.BOTTOM,
    );*/
    if (feeList != null) {
      for (var fee in feeList) {
        if (kDebugMode) {
          print(
            'ID: ${fee.id}, Name: ${fee.name}, Type: ${fee.type}, Amount: ${fee.amount}',
          );
        }

        if (strFeesType.toString() == fee.name.toString()) {
          feesAndTaxesAmount = double.parse(fee.amount.toString());
        }
      }
      /*debugPrint('========================');
      debugPrint('Fee amount is: ====> $feesAndTaxesAmount');
      debugPrint('========================');*/
      // return;

      if (feesAndTaxesAmount == 0 || feesAndTaxesAmount == 0.0) {
        /* debugPrint('====================================');
        debugPrint('===== BY PASS WITHOUT CONV FEE =====');
        debugPrint('====================================');*/
        /*customToast(
          '5. No conv fee is: $feesAndTaxesAmount',
          Colors.red,
          ToastGravity.BOTTOM,
        );*/
        validateCard();
      } else {
        /*debugPrint('====================================');
        debugPrint('======= DEDUCT CONV FEE ============');
        debugPrint('====================================');*/
        /* customToast(
          '5. Yes, tax amount is: $feesAndTaxesAmount',
          Colors.red,
          ToastGravity.BOTTOM,
        );*/
        validateCard();
      }
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
    }
    /*debugPrint('===============================================');
      debugPrint('======= CARD VALIDATE SUCCESSFULLY ============');
      debugPrint('===============================================');*/
    /*customToast(
      '6: Card validate successfully',
      Colors.red,
      ToastGravity.BOTTOM,
    );*/
    final cardDetails = SavedCardDetails(
      cardNumber: _contCardNumber.text.toString(),
      cardholderName: _contCardHolderName.text,
      expMonth: _contCardExpMonth.text.toString(),
      expYear: _contCardExpYear.text.toString(),
      cvv: _contCVV.text.toString(),
    );
    /*if (kDebugMode) {
      print(cardDetails.cardNumber);
      print(_contCardHolderName.text);
      print(cardDetails.expMonth);
      print(cardDetails.expYear);
      print(cardDetails.cvv);
    }*/
    //
    /*customToast(
      '7: Stripe Token: ${cardDetails.cardNumber}',
      Colors.red,
      ToastGravity.BOTTOM,
    );*/
    isByPass = true;
    handleStripeTokenCreation(cardDetails);

    ///
    ///
    ///
    ///
    /*if (storeStripeCustomerId == '') {
        debugPrint('There is no stripe customer key created');
        handleStripeTokenCreation(cardDetails);
      } else {
        debugPrint(
          'Bypass fees <==> Yes, there is stripe custom key. Now add card directly without fee and all',
        );
        isByPass = true;
        handleStripeTokenCreation(cardDetails);
      }*/
  }

  void handleStripeTokenCreation(cardDetails) async {
    /*customToast(
      'Name: ${loginUserName()}, Email: ${loginUserEmail()}',
      Colors.red,
      ToastGravity.BOTTOM,
    );*/

    final result = await createStripeToken(
      cardNumber: cardDetails.cardNumber,
      expMonth: cardDetails.expMonth,
      expYear: cardDetails.expYear,
      cvc: cardDetails.cvv,
    );

    if (result['success'] == true) {
      /*if (kDebugMode) {
        print('Token ID: ${result['tokenId']}');
      }*/

      // logger.d(feesAndTaxesAmount);
      if (isByPass == true) {
        if (feesAndTaxesAmount != 0 || feesAndTaxesAmount != 0.0) {
          /*customToast(
            '8: Fees',
            Colors.red,
            ToastGravity.BOTTOM,
          );*/
          processPayment(
            context,
            _contCardHolderName.text.toString(),
            cardDetails.cardNumber,
            cardDetails.expMonth,
            cardDetails.expYear,
            cardDetails.cvv,
            feesAndTaxesAmount,
            'cardSavedStatus',
          );
        } else {
          // fee amount is zero now add card directly
          debugPrint('=======================================================');
          debugPrint('======= ADD AND SUBSCRIBE WITHOUT CONV FEES ===========');
          debugPrint('=======================================================');
          /*customToast(
            '7: Add card to evs server',
            Colors.red,
            ToastGravity.BOTTOM,
          );*/
          _addCardInEvsServer(context);
        }
      } else {
        /*customToast(
          '9: FeesRegister',
          Colors.red,
          ToastGravity.BOTTOM,
        );*/
        // sucess
        _registerCustomerInStripe(
          cardDetails.cardNumber,
          cardDetails.expMonth,
          cardDetails.expYear,
          cardDetails.cvv,
          result['tokenId'].toString(),
        );
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

  void _registerCustomerInStripe(
    number,
    month,
    year,
    cvv,
    stripeToken,
  ) async {
    debugPrint('API ==> REGISTER CUSTOMER IN STRIPE 3');
    //
    // showLoadingUI(context, 'please wait...');
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();

    final parameters = {
      'action': 'customer',
      'userId': userId,
      'name': loginUserName(),
      'email': loginUserEmail(),
      'tokenID': stripeToken.toString()
    };
    if (kDebugMode) {
      print(parameters);
    }
    // return;

    try {
      final response = await _apiService2.stripePostRequest(parameters, token);
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      debugPrint('one');
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];
      String customerIdIs = '';
      if (successStatus == 'Fails') {
      } else {
        customerIdIs = jsonResponse['customer_id'];
      }

      debugPrint('two');
      /*if (kDebugMode) {
        print('STATUS ==> $successStatus');
        print(successMessage);
      }*/

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');
        //
        if (successMessage == NOT_AUTHORIZED) {
          //
          _apiServiceGT
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
            _registerCustomerInStripe(
              number,
              month,
              year,
              cvv,
              stripeToken,
            );
          });
        } else {
          if (successStatus.toLowerCase() == 'success') {
            //
            // Navigator.pop(context);
            debugPrint('====> SUCCESS <====');
            //
            editAfterCreateStripeCustomer(context, customerIdIs);
          }
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }*/
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters;

    parameters = {
      'action': 'customer',
      'userId': userId,
      'name': loginUserName(),
      'email': loginUserEmail(),
      'tokenID': stripeToken.toString()
    };

    if (kDebugMode) {
      print(parameters);
    }
    // return;

    try {
      final response = await _apiService2.stripePostRequest(parameters, token);
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];
      String customerIdIs = '';
      if (successStatus == 'Fails') {
      } else {
        customerIdIs = jsonResponse['customer_id'];
      }

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');
        //
        if (successMessage == NOT_AUTHORIZED) {
          //
          _apiServiceGT
              .generateToken(
            userId,
            FirebaseAuth.instance.currentUser!.email,
            roleIs.toString(),
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            _registerCustomerInStripe(
              number,
              month,
              year,
              cvv,
              stripeToken,
            );
          });
        } else {
          // edit customer id in evs
          editAfterCreateStripeCustomer(context, customerIdIs);
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  void editAfterCreateStripeCustomer(
    context,
    customerId,
  ) async {
    debugPrint('API ==> EDIT PROFILE');
    // String parseDevice = await deviceIs();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters;
    if (STRIPE_STATUS == 'T') {
      parameters = {
        'action': 'editProfile',
        'userId': userId,
        'stripe_customer_id_Test': customerId,
      };
    } else {
      parameters = {
        'action': 'editProfile',
        'userId': userId,
        'stripe_customer_id_Live': customerId,
      };
    }
    if (kDebugMode) {
      print(parameters);
    }
    // return;

    try {
      final response = await _apiService2.postRequest(parameters, token);
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];
      /*if (kDebugMode) {
        print('STATUS ==> $successStatus');
        print(successMessage);
      }*/

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');
        //
        if (successMessage == NOT_AUTHORIZED) {
          //
          _apiServiceGT
              .generateToken(
            userId,
            FirebaseAuth.instance.currentUser!.email,
            roleIs.toString(),
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            editAfterCreateStripeCustomer(context, customerId);
          });
        } else {
          //
          Navigator.pop(context);
          fetchProfileData();
          //  createStripeCustomerAccount(customerId);
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  sucessEverythingNowGoBack() {
    Navigator.pop(context);
    // Navigator.pop(context, REFRESH_CONVENIENCE_FEES);
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

  /// PAY
  void processPayment(
    BuildContext context,
    name,
    number,
    month,
    year,
    cvv,
    amount,
    cardSavedStatus,
  ) async {
    debugPrint('STRIPE: Create token hit');
    if (kDebugMode) {
      print(amount);
    }
    // return;
    final result = await createStripeToken(
        cardNumber: number.toString(),
        expMonth: month.toString(),
        expYear: year.toString(),
        cvc: cvv.toString());

    if (result['success'] == true) {
      //
      if (kDebugMode) {
        print('=============================================================');
        print('Token ID: ${result['tokenId']}. Now deduct money from stripe.');
        print('=============================================================');
      }
      chargeMoneyFromStripeAndAddToEvsServer(
        amount,
        result['tokenId'].toString(),
        cardSavedStatus,
        number.toString(),
        month.toString(),
        year.toString(),
        cvv.toString(),
      );
    } else {
      //
      if (kDebugMode) {
        print('Error');
      }
    }
  }

  chargeMoneyFromStripeAndAddToEvsServer(
    amount,
    token,
    getCardSavedStatus,
    number,
    month,
    year,
    cvv,
  ) async {
    debugPrint('API: Charge amount: Send stripe data to server.');
    // showLoadingUI(context, 'Please wait...');
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    //
    if (kDebugMode) {
      print('===================================');
      print('CONVENIENCE FEES IS: ====> $amount');
      print('===================================');
    }
    var intAmount = double.parse(amount.toString());
    final response = await stripeService.chargeMoneyFromStripeAfterGettingToken(
      amount: double.parse(intAmount.toString()),
      stripeCardToken: token,
      type: 'Fix',
    );

    if (kDebugMode) {
      print('===================================');
      print(response);
      print(response!.message);
      print('===================================');
    }
    if (response != null) {
      if (response.status == 'Fail') {
        debugPrint('API: FAILS.');
        Navigator.pop(context);
        customToast(
          response.message,
          Colors.redAccent,
          ToastGravity.BOTTOM,
        );
      } else if (response.status == 'NOT_AUTHORIZED') {
        debugPrint('CHARGE AMOUNT API IS NOT AUTHORIZE. PLEASE AUTHORIZE');
        _apiServiceGT
            .generateToken(
          userId,
          loginUserEmail(),
          roleIs,
        )
            .then((v) {
          if (kDebugMode) {
            print('TOKEN ==> $v');
          }
          // again click
          chargeMoneyFromStripeAndAddToEvsServer(
            amount,
            token,
            getCardSavedStatus,
            number.toString(),
            month.toString(),
            year.toString(),
            cvv.toString(),
          );
        });
        return;
      } else {
        debugPrint(
          'Success: Payment deducted from stripe. Now create UNIT bank account',
        );

        // NOE CREATE A UNIT BANK ACCOUNT
        //  sucessEverythingNowGoBack();
        _addCardInEvsServer(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  // now subscripbe this card
  void createStripeCustomerAccount(customerId) async {
    // debugPrint('API ==> Stripe subscription');
    //
    // showLoadingUI(context, 'please wait...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();

    final parameters = {
      'action': 'subscription',
      'userId': userId,
      'customerId': customerId,
      'plan_type': 'Card'
    };
    if (kDebugMode) {
      print(parameters);
    }

    try {
      final response =
          await _apiService2.stripeCreateRequest(parameters, token);
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
          _apiServiceGT
              .generateToken(userId, loginUserEmail(), roleIs)
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
          });
        } else {
          if (successStatus.toLowerCase() == 'success') {
            //
            // Navigator.pop(context);
            // logger.d('SUCCESS: SUBSCRIPTION');
            /*customToast(
              '12: Subscription',
              Colors.redAccent,
              ToastGravity.BOTTOM,
            );*/
            sucessEverythingNowGoBack();
          }
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
}
