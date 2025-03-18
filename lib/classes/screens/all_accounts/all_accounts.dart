import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/stripe/generate_token/generate_token.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/model/model.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/sheet/alreadySavedCardSheet.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/sheet/sheet.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/fee_calculator/fee_calculator.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/get_price.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/model/model.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/model/model.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/save_get_card.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/screens/all_accounts/account_details/account_details.dart';
import 'package:ride_card_app/classes/screens/convenience_fee/convenience_fees.dart';
import 'package:ride_card_app/classes/service/UNIT/ACCOUNT/create_account/create_account.dart';
import 'package:ride_card_app/classes/service/UNIT/CUSTOMER/get_customer_accounts_list/get_customer_account_list.dart';
import 'package:ride_card_app/classes/service/charge_money_from_stripe/charge_money_from_stripe.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
// import 'package:uuid/uuid.dart';

class AllAccountsScreen extends StatefulWidget {
  const AllAccountsScreen({super.key});

  @override
  State<AllAccountsScreen> createState() => _AllAccountsScreenState();
}

class _AllAccountsScreenState extends State<AllAccountsScreen> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final stripeService = ChargeMoneyStripeService();
  final GenerateTokenService _apiServiceGT = GenerateTokenService();
  final ApiService _apiService = ApiService();

  var customerID = '0';
  List<dynamic>? accountDetails;
  var screenLoader = true;
  bool floatingVisibility = false;
  bool? accountCreated;
  var myFullData;
  var accountStatusMessage = 'No account added yet. Click plus to add.';
  var customerType = '';
  //
  String feesAndTaxesType = '';
  double feesAndTaxesAmount = 0.0;
  double calculatedFeeAmount = 0.0;
  double totalAmountAfterCalculateFee = 0.0;
  bool removePopLoader = false;
  double showConvenienceFeesOnPopup = 0.0;
  var savedCardDetailsInDictionary;
  var storeStripeCustomerId = '';
  //
  @override
  void initState() {
    debugPrint('====> ALL ACCOUNTS SCREEN <====');
    //
    debugPrint(loginUserEmail());
    // fetchProfileData();
    getFeesAndTaxes();
    super.initState();
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
        if (fee.name == 'feeOnCreatingMoreThanOneBankAccount') {
          debugPrint('====> MORE THEN ONE BANK ACCOUNT <====');
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
            // (feesAndTaxesAmount * 10) / 100;
            totalAmountAfterCalculateFee = feesAndTaxesAmount;
            // (feesAndTaxesAmount * 10) / 100;
            // return;
          }
        }
      }
      if (feesAndTaxesType == TAX_TYPE_PERCENTAGE) {
        String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
        showConvenienceFeesOnPopup = double.parse(formattedValue.toString());
        // if (kDebugMode) {
        //   print(showConvenienceFeesOnPopup);
        // }
        // FEES CALCULATOR
        calculateFeesAndReturnValue();
      } else {
        if (kDebugMode) {
          // print(showConvenienceFeesOnPopup);
          // String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
          // print(formattedValue);
        }
        String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
        showConvenienceFeesOnPopup = double.parse(formattedValue.toString());
        if (kDebugMode) {
          print(showConvenienceFeesOnPopup);
        }
        // API
        fetchProfileData();
      }
    } else {
      if (kDebugMode) {
        print('Failed to retrieve fee data.');
      }
    }
  }

  calculateFeesAndReturnValue() {
    double calculatedFee = FeeCalculator.calculateFee(
      feesAndTaxesType,
      feesAndTaxesAmount,
    );
    totalAmountAfterCalculateFee = calculatedFee;
    if (kDebugMode) {
      print(totalAmountAfterCalculateFee);
    }
    // API
    fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Visibility(
        visible: floatingVisibility,
        child: FloatingActionButton(
          onPressed: () {
            //

            if (accountDetails!.isEmpty) {
              logger.d('First account');
              _openBottomSheet();
            } else {
              areYourSureCreateAccountPopup(
                context,
                totalAmountAfterCalculateFee,
              );
            }
          },
          tooltip: 'Add account',
          backgroundColor: hexToColor(appORANGEcolorHexCode),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: _UIKit(context),
    );
  }

  void _openBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: BottomSheetForm(title: 'bank account'),
        );
      },
    );

    if (result != null) {
      // Print or use the result values here
      if (kDebugMode) {
        print("Account Number: ${result['accountNumber']}");
        print("Exp Date: ${result['expDate']}");
        print("Exp Year: ${result['expYear']}");
        print("CVV: ${result['cvv']}");
      }
      checkUserData(result);
    }
  }

  Future<void> checkUserData(result) async {
    await sendRequestToProfileDynamic().then((v) async {
      if (kDebugMode) {
        //  print(v);
      }
      if (STRIPE_STATUS == 'T') {
        storeStripeCustomerId = v['data']['stripe_customer_id_Test'];
      } else {
        storeStripeCustomerId = v['data']['stripe_customer_id_Live'];
      }
      //
      logger.d(storeStripeCustomerId);
      final newStripeToken = await createStripeToken(
          cardNumber: result['accountNumber'].toString(),
          expMonth: result['expDate'].toString(),
          expYear: result['expYear'].toString(),
          cvc: result['cvv'].toString());

      //
      logger.d(newStripeToken);
      showLoadingUI(context, 'please wait...');
      if (storeStripeCustomerId != '') {
        createStripeCustomerAccount(storeStripeCustomerId);
      } else {
        _registerCustomerInStripe(newStripeToken);
      }
    });
  }

  void _registerCustomerInStripe(stripeToken) async {
    debugPrint('API ==> REGISTER CUSTOMER IN STRIPE 1');

    ///
    String? customerId =
        await RegisterCustomerInStripe().registerCustomerInStripe(stripeToken);

    if (customerId != null) {
      bool isProfileEdited = await RegisterCustomerInStripe()
          .editAfterCreateStripeCustomer(customerId);

      if (isProfileEdited) {
        bool isSubscriptionCreated =
            await RegisterCustomerInStripe().createSubscription(customerId);

        if (isSubscriptionCreated) {
          logger.d('Subscription created successfully.');
          Navigator.pop(context);
          _createUnitBankAccount(context);
        } else {
          debugPrint('Failed to create subscription.');
        }
      } else {
        debugPrint('Failed to edit profile.');
      }
    } else {
      debugPrint('Failed to register customer in Stripe.');
    }

    ///
    /*String? customerId =
        await RegisterCustomerInStripe().registerCustomerInStripe(stripeToken);

    if (customerId != null) {
      if (kDebugMode) {
        logger.d('Customer registered with ID: $customerId');
      }
      editAfterCreateStripeCustomer(context, customerId);
    } else {
      if (kDebugMode) {
        print('Customer registration failed');
      }
    }*/

    // Step 1: Register customer in Stripe
    /* String? customerId =
        await RegisterCustomerInStripe().registerCustomerInStripe(stripeToken);

    if (customerId != null) {
      bool isProfileEdited =
          await RegisterCustomerInStripe().editAfterCreateStripeCustomer(
        customerId,
      );

      if (isProfileEdited) {
        debugPrint(
          'Profile updated successfully after creating Stripe customer.',
        );
      } else {
        debugPrint(
          'Failed to update profile after creating Stripe customer.',
        );
      }
    } else {
      debugPrint('Failed to register customer in Stripe.');
    }*/

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

    try {
      final response = await _apiService.stripePostRequest(parameters, token);
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];
      String customerIdIs = jsonResponse['customer_id'];

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
              .generateToken(
            userId,
            loginUserEmail(),
            roleIs,
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            _registerCustomerInStripe(token);
          });
        } else {
          if (successStatus.toLowerCase() == 'success') {
            //
            // Navigator.pop(context);
            logger.d(customerIdIs);
            logger.d('CUSTOMER IN STRIPE CREATED SUCCESSFULLY');
            editAfterCreateStripeCustomer(context, customerIdIs);
            // editAfterCreateStripeCustomer(context, customerIdIs);
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
  }

  /*void editAfterCreateStripeCustomer(
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
    final parameters = {
      'action': 'editProfile',
      'userId': userId,
      'stripe_customer_id_Test': customerId,
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
          _apiServiceGT
              .generateToken(
            userId,
            loginUserEmail(),
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
          createStripeCustomerAccount(customerId);
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }*/

  ///
  // dummy
  void createStripeCustomerAccount(customerId) async {
    debugPrint('API ==> Stripe subscription');
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
      'plan_type': 'Account'
    };
    if (kDebugMode) {
      print(parameters);
    }

    try {
      final response = await _apiService.stripeCreateRequest(parameters, token);
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
              .generateToken(
            userId,
            loginUserEmail(),
            roleIs,
          )
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
            logger.d('SUCCESS: SUBSCRIPTION');
            Navigator.pop(context);
            _createUnitBankAccount(context);
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

  void areYourSureCreateAccountPopup(
    BuildContext context,
    convenienceFee,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: totalAmountAfterCalculateFee != 0.0
                        ? Column(
                            children: [
                              textFontPOOPINS(
                                //
                                'Are you sure you want to create a bank account ?',
                                Colors.black,
                                18.0,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: textFontPOOPINS(
                                  //
                                  '\nConvenience fee: \$$showConvenienceFeesOnPopup',
                                  Colors.black,
                                  12.0,
                                ),
                              ),
                            ],
                          )
                        : textFontPOOPINS(
                            //
                            'Are you sure you want to create a bank account ?',
                            Colors.black,
                            18.0,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: Center(
                          child: textFontPOOPINS(
                            'dismiss',
                            Colors.grey,
                            12.0,
                          ),
                        ),
                      ),
                    ),
                    //
                    const SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        //
                        Navigator.pop(context);
                        //
                        if (kDebugMode) {
                          print(accountDetails!.length);
                        }
                        pushToPayFeesAndChargesInAllBankAccountScreen(context);
                        /*if (accountDetails!.length > 1) {
                          debugPrint(
                            'BANK ACCOUNT COUNT IS MORE THAN 1. Charge Convenience Fee: $showConvenienceFeesOnPopup',
                          );
                          openCardBottomSheet(context);
                        } else {
                          debugPrint(
                            'BANK ACCOUNT IS ZERO. DO NOT CHARGE MONEY',
                          );
                        }*/
                        // _createAccount(context);
                      },
                      child: Container(
                        height: 40,
                        width: totalAmountAfterCalculateFee != 0.0 ? 140 : 100,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: Center(
                          child: totalAmountAfterCalculateFee != 0.0
                              ? textFontPOOPINS(
                                  'Pay & Create',
                                  Colors.white,
                                  14.0,
                                )
                              : textFontPOOPINS(
                                  'Create',
                                  Colors.white,
                                  14.0,
                                ),
                        ),
                      ),
                    ),
                    //
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _createUnitBankAccount(context) async {
    totalAmountAfterCalculateFee != 0.0
        ? const SizedBox()
        : showLoadingUI(context, 'please wait...');
    var response = await CreateAccountService.createAccount(customerID);
    setState(() {
      accountCreated = true;
    });

    // Print the result to check it
    if (response != null) {
      debugPrint('Account created successfully.');
      if (kDebugMode) {
        print('================ created account details =====================');
        print(response);
        print('==============================================================');
      }
      String depositAccountId = response['data']['id'];
      String routingNumber = response['data']['attributes']['routingNumber'];
      String accountNumber = response['data']['attributes']['accountNumber'];
      String customerId =
          response['data']['relationships']['customer']['data']['id'];

      // Print values
      if (kDebugMode) {
        print('Deposit Account ID: $depositAccountId');
        print('Routing Number: $routingNumber');
        print('Account Number: $accountNumber');
        print('Customer ID: $customerId');
      }
      nowAddBankAccountDetailsInOurServer(
        depositAccountId,
        routingNumber,
        accountNumber,
        customerId,
      );
    } else {
      debugPrint('Failed to create account.');
    }
  }

  nowAddBankAccountDetailsInOurServer(
    depositAccountId,
    routingNumber,
    accountNumber,
    customerId,
  ) async {
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();

    final parameters = {
      'action': 'accountadd',
      'userId': userId,
      'account_number': accountNumber,
      'unitCustomerId': customerId,
      'unitBankId': depositAccountId,
      'unitBankType': 'deposit',
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
          _apiServiceGT
              .generateToken(
            userId,
            loginUserEmail(),
            roleIs,
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            nowAddBankAccountDetailsInOurServer(
              depositAccountId,
              routingNumber,
              accountNumber,
              customerId,
            );
          });
        } else {
          if (successStatus.toLowerCase() == 'success') {
            //
            successCreated();
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

  successCreated() {
    removePopLoader = true;
    totalAmountAfterCalculateFee != 0.0 ? const SizedBox() : const SizedBox();
    //Navigator.pop(context);
    customToast('created', Colors.green, ToastGravity.BOTTOM);
    fetchAccountDetails();
  }

  // TAXES AND CHARGES
  // OPEN BOTTOM SHEET WHEN THERE IS FEES
  /*void openCardBottomSheet(BuildContext context) async {
    final result = await showCardBottomSheet(context);

    if (result != null && result['topButtonClicked'] == true) {
      // Top button was clicked
      if (kDebugMode) {
        print('Top button was clicked');
      }

      final savedCardDetails = await getUserSavedCardDetails(loginUserId());
      if (savedCardDetails != false) {
        // Data exists, and you can access it from savedCardDetails
        if (kDebugMode) {
          print(savedCardDetails);
        }
        savedCardDetailsInDictionary = savedCardDetails;

        ///
        Timer(const Duration(milliseconds: 500), handleTimeout);

        ///
      } else {
        // No data found
        debugPrint('No card is saved in Firebase');
      }
    } else if (result != null) {
      // Card details were submitted
      final cardDetails = result['cardDetails'] as CardDetailsForTaxAndFees;
      final saveCard = result['saveCard'] as bool;
      if (kDebugMode) {
        print(saveCard);
      }
      // Use cardDetails and saveCard as needed
      if (kDebugMode) {
        print('Cardholder Name: ${cardDetails.cardholderName}');
        print('Card Number: ${cardDetails.cardNumber}');
        print('Exp. Month: ${cardDetails.expMonth}');
        print('Exp. Year: ${cardDetails.expYear}');
        print('CVV: ${cardDetails.cvv}');
        print('SAVED: ${cardDetails.saveCard}');
      }
      // start processing payment
      processPayment(
        context,
        cardDetails.cardholderName,
        cardDetails.cardNumber,
        cardDetails.expMonth,
        cardDetails.expYear,
        cardDetails.cvv,
        totalAmountAfterCalculateFee,
        cardDetails.saveCard,
        // convertDollarToCentsInDouble(totalAmountAfterCalculateFee),
      );
    }
  }*/

  // OPEN BOTTOM SHEET WITH ENTER CARD DETAILS
  void openCardBottomSheet(BuildContext context) async {
    final result = await showCardBottomSheet(context);

    if (result == null) return;

    if (result['topButtonClicked'] == true) {
      await handleTopButtonClicked(context);
    } else {
      final cardDetails = result['cardDetails'] as CardDetailsForTaxAndFees;
      final saveCard = result['saveCard'] as bool;
      await processCardPayment(context, cardDetails, saveCard);
    }
  }

  // USER CLICK SAVED CARD BUTTON
  Future<void> handleTopButtonClicked(BuildContext context) async {
    final savedCardDetails = await getUserSavedCardDetails(loginUserId());

    if (savedCardDetails != false) {
      savedCardDetailsInDictionary = savedCardDetails;
      Timer(const Duration(milliseconds: 500), handleTimeout);
    } else {
      debugPrint('No card is saved in Firebase');
    }
  }

  // ALL ENTERED OR SAVED CARD DETAILS RETURN
  Future<void> processCardPayment(
    BuildContext context,
    CardDetailsForTaxAndFees cardDetails,
    bool saveCard,
  ) async {
    if (kDebugMode) {
      print('Cardholder Name: ${cardDetails.cardholderName}');
      print('Card Number: ${cardDetails.cardNumber}');
      print('Exp. Month: ${cardDetails.expMonth}');
      print('Exp. Year: ${cardDetails.expYear}');
      print('CVV: ${cardDetails.cvv}');
      print('Save Card: $saveCard');
    }

    processPayment(
      context,
      cardDetails.cardholderName,
      cardDetails.cardNumber,
      cardDetails.expMonth,
      cardDetails.expYear,
      cardDetails.cvv,
      totalAmountAfterCalculateFee,
      saveCard,
    );
  }

  // IF USER CLICK ON SAVED CARD SO THAT CALLED
  void handleTimeout() async {
    final cardDetails = SavedCardDetails(
      cardNumber: savedCardDetailsInDictionary['cardNumber'],
      cardholderName: savedCardDetailsInDictionary['cardHolderName'],
      expMonth: savedCardDetailsInDictionary['cardExpMonth'],
      expYear: savedCardDetailsInDictionary['cardExpYear'],
      cvv: '', // CVV will be input by the user
    );

    final updatedCardDetails = await showCardDetailsDialog(
      context,
      cardDetails,
    );

    if (updatedCardDetails != null) {
      if (kDebugMode) {
        print('Cardholder Name: ${updatedCardDetails.cardholderName}');
        print('Card Number: ${updatedCardDetails.cardNumber}');
        print('Exp. Month: ${updatedCardDetails.expMonth}');
        print('Exp. Year: ${updatedCardDetails.expYear}');
        print('CVV: ${updatedCardDetails.cvv}');
        // print('SAVED: ${updatedCardDetails.saveCard}');
      }

      processPayment(
        context,
        updatedCardDetails.cardholderName,
        updatedCardDetails.cardNumber,
        updatedCardDetails.expMonth,
        updatedCardDetails.expYear,
        updatedCardDetails.cvv,
        totalAmountAfterCalculateFee,
        true,
        // convertDollarToCentsInDouble(totalAmountAfterCalculateFee),
      );
    }
  }

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
    final token = await createStripeToken(
        cardNumber: number.toString(),
        expMonth: month.toString(),
        expYear: year.toString(),
        cvc: cvv.toString());

    // Use the token for further processing, such as making a payment
    if (kDebugMode) {
      print('Received token: $token');
      print('Stripe amount to send: $amount');
      print('Stripe amount to send: $cardSavedStatus');
    }

    if (cardSavedStatus == true) {
      final card = CardModel(
        userId: loginUserId(),
        cardHolderName: loginUserName(),
        cardNumber: number.toString(),
        cardExpMonth: month.toString(),
        cardExpYear: year.toString(),
        cardId: const Uuid().v4(),
        cardStatus: true,
      );

      final success = await SavedCardService.saveUserCardInRealDB(card);
      if (success) {
        debugPrint('Firebase: Card saved successfully');
        // API: Charge amount
      } else {
        debugPrint('Failed to save card');
      }
    } else {}
    chargeMoneyFromStripeAndAddToEvsServer(
      amount,
      token,
      cardSavedStatus,
    );
  }

  chargeMoneyFromStripeAndAddToEvsServer(
    amount,
    token,
    getCardSavedStatus,
  ) async {
    debugPrint('API: Charge amount: Send stripe data to server.');
    showLoadingUI(context, 'Please wait...');
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
    final response = await stripeService.chargeMoneyFromStripeAfterGettingToken(
      amount: amount,
      stripeCardToken: token,
      type: feesAndTaxesType,
    );

    if (kDebugMode) {
      print(response!.message);
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
          );
        });
        return;
      } else {
        debugPrint(
          'Success: Payment deducted from stripe. Now create UNIT bank account',
        );
        //

        // NOE CREATE A UNIT BANK ACCOUNT
        _createUnitBankAccount(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  Container _UIKit(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: accountDetails == null
          ? Center(
              child: textFontPOOPINS(
                'please wait...',
                Colors.white,
                14.0,
              ),
            )
          : accountDetails!.isEmpty
              ? _dataNotInListUIKit(context)
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _UIKitAccountsAfterBG(context),
                ),
    );
  }

  Center _dataNotInListUIKit(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
              customerID == ''
                  ? Expanded(
                      child: Center(
                        child: textFontPOOPINS(
                          ' Something went wrong. Please go back and try again',
                          Colors.redAccent,
                          12.0,
                        ),
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: textFontPOOPINS(
                          accountStatusMessage,
                          Colors.white,
                          14.0,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _UIKitAccountsAfterBG(BuildContext context) {
    return screenLoader == true
        ? const SizedBox()
        : Column(
            children: [
              const SizedBox(
                height: 80.0,
              ),
              customNavigationBar(
                //
                context,
                TEXT_NAVIGATION_TITLE_ACCOUNTS,
              ),
              for (int i = 0; i < accountDetails!.length; i++) ...[
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Container(
                    // height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                        ),
                        child: svgImage(
                          'bank',
                          14.0,
                          14.0,
                        ),
                      ),
                      title: textFontPOOPINS(
                        //
                        accountDetails![i]['attributes']['accountNumber'],
                        Colors.black,
                        16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      subtitle: textFontPOOPINS(
                        //
                        accountDetails![i]['type'],
                        Colors.grey,
                        10.0,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (accountDetails![i]['attributes']['status'] ==
                              'Open') ...[
                            textFontORBITRON(
                              accountDetails![i]['attributes']['status'],
                              Colors.green,
                              10.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ] else if (accountDetails![i]['attributes']
                                  ['status'] ==
                              'Frozen') ...[
                            textFontORBITRON(
                              accountDetails![i]['attributes']['status'],
                              Colors.orange,
                              10.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ] else if (accountDetails![i]['attributes']
                                  ['status'] ==
                              'Closed') ...[
                            textFontORBITRON(
                              accountDetails![i]['attributes']['status'],
                              Colors.redAccent,
                              10.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ]
                        ],
                      ),
                      onTap: () {
                        //
                        pushToAccountDetails(context, accountDetails![i]);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ]
            ],
          );
    //
  }

  // EVS: API => GET USER PROFILE DATA
  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) {
      myFullData = v;
      //
      // print(myFullData);
      //  customerID = '1992974';
      customerID = myFullData['data']['customerId'].toString();
      debugPrint('CUSTOM ID ==> $customerID');
      if (customerID == '') {
        setState(() {
          screenLoader = false;
          floatingVisibility = false;
          accountDetails = [];
        });
      } else if (customerID == '0') {
        setState(() {
          screenLoader = false;
          floatingVisibility = false;
          accountDetails = [];
        });
      } else {
        fetchAccountDetails();
      }
    });
    // print(responseBody);
  }

  Future<void> fetchAccountDetails() async {
    accountDetails = await GetAllUnitAccountsService
        .getParticularAccountDetailsViaCustomerId(customerID);

    getCustomerById();
  }

  Future<void> getCustomerById() async {
    final url = Uri.parse('$SANDBOX_LIVE_URL/customers/$customerID');
    if (kDebugMode) {
      print(url);
    }
    var token = TESTING_TOKEN;

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);
        debugPrint('=========== GET CUSTOMER BY ID ========================');
        if (kDebugMode) {
          print(jsonData);
          debugPrint('=======================================================');
        }
        // Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        customerType = jsonData['data']['type'].toString();
        setState(() {
          screenLoader = false;
          floatingVisibility = true;
        });

        if (removePopLoader != false) {
          totalAmountAfterCalculateFee != 0.0
              ? const SizedBox() // Navigator.pop(context)
              : const SizedBox();
        }

        // updateCustomerData(jsonData['data']['id'].toString());
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print(jsonData);
        }
        setState(() {
          accountStatusMessage =
              'You account is not active yet. Please contact support. \n\nCustomer Id: $customerID';
          screenLoader = false;
          floatingVisibility = false;
        });
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  Future<void> pushToAccountDetails(BuildContext context, data) async {
    //
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountDetailsScreen(
            accountData: data,
            bankType: customerType,
          ),
        ));

    if (!mounted) return;
    //
    if (result == 'reload_screen') {
      if (kDebugMode) {
        print(result);
      }
      fetchAccountDetails();
      // funcGetLocalDBdata();
    }
  }

  Future<void> pushToPayFeesAndChargesInAllBankAccountScreen(
    BuildContext context,
  ) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConvenienceFeesChargesScreen(
          title: FEES_CHARGE_TITLE,
          feeType: 'feeOnCreatingMoreThanOneBankAccount',
        ),
      ),
    );

    if (!mounted) return;
    //
    if (result == REFRESH_CONVENIENCE_FEES) {
      if (kDebugMode) {
        print(result);
      }
      // showLoadingUI(context, 'please wait...');
      _createUnitBankAccount(context);
    }
  }
}

class BottomSheetForm extends StatefulWidget {
  const BottomSheetForm({super.key, required this.title});

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _BottomSheetFormState createState() => _BottomSheetFormState();
}

class _BottomSheetFormState extends State<BottomSheetForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _expDateController = TextEditingController();
  final TextEditingController _expYearController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _accountNumberController.dispose();
    _expDateController.dispose();
    _expYearController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Collect values
      Navigator.pop(context, {
        'accountNumber': _accountNumberController.text,
        'expDate': _expDateController.text,
        'expYear': _expYearController.text,
        'cvv': _cvvController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textFontPOOPINS(
                "To Create a new ${widget.title}, you will need to provide your card details for maintenance purpose. A \$2 monthly maintenance fee will automatically be charged from your added card. This fee ensures your account remains active and up-to-date.",
                Colors.black,
                14.0,
              ),
              // Account Number Field
              TextFormField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  return null;
                },
                maxLength: 16,
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  // Exp Date Field (Month)
                  Expanded(
                    child: TextFormField(
                      controller: _expDateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Exp Date',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter expiry month';
                        }
                        return null;
                      },
                      maxLength: 2,
                    ),
                  ),
                  const SizedBox(width: 10.0),

                  // Exp Year Field
                  Expanded(
                    child: TextFormField(
                      controller: _expYearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Exp Year',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter expiry year';
                        }
                        return null;
                      },
                      maxLength: 2,
                    ),
                  ),
                  const SizedBox(width: 10.0),

                  // CVV Field
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter CVV';
                        }
                        return null;
                      },
                      maxLength: 3,
                    ),
                  ),
                ],
              ),
              // Exp Date Field
              /* TextFormField(
                controller: _expDateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Exp Date (MM)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiry month';
                  }
                  return null;
                },
                maxLength: 2,
              ),
              const SizedBox(height: 10.0),
              // Exp Year Field
              TextFormField(
                controller: _expYearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Exp Year (YY)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiry year';
                  }
                  return null;
                },
                maxLength: 2,
              ),
              const SizedBox(height: 10.0),
              // CVV Field
              TextFormField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CVV';
                  }
                  return null;
                },
                maxLength: 3,
              ),*/
              const SizedBox(height: 20.0),
              // Submit Button
              ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
