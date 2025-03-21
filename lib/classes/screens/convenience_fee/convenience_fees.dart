import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/stripe/generate_token/generate_token.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/sheet/alreadySavedCardSheet.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/fee_calculator/fee_calculator.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/get_price.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/model/model.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/model/model.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/save_get_card.dart';
import 'package:ride_card_app/classes/service/charge_money_from_stripe/charge_money_from_stripe.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ConvenienceFeesChargesScreen extends StatefulWidget {
  const ConvenienceFeesChargesScreen(
      {super.key, required this.feeType, required this.title});

  final String title;
  final String feeType;

  @override
  State<ConvenienceFeesChargesScreen> createState() =>
      _ConvenienceFeesChargesScreenState();
}

class _ConvenienceFeesChargesScreenState
    extends State<ConvenienceFeesChargesScreen> {
  final ApiService _apiService2 = ApiService();

  final GenerateTokenService _apiServiceGT = GenerateTokenService();
  final TextEditingController contCardNumber = TextEditingController();
  final TextEditingController contCardExpMonth = TextEditingController();
  final TextEditingController contCardExpYear = TextEditingController();
  final TextEditingController contCardCVV = TextEditingController();

  final stripeService = ChargeMoneyStripeService();
  // final GenerateTokenService _apiServiceGT = GenerateTokenService();

  bool screenLoader = true;
  String feesAndTaxesType = '';
  double feesAndTaxesAmount = 0.0;
  double calculatedFeeAmount = 0.0;
  double totalAmountAfterCalculateFee = 0.0;
  bool removePopLoader = false;
  double showConvenienceFeesOnPopup = 0.0;
  var savedCardDetailsInDictionary;
  bool userSavedCard = false;
  bool saveCard = false;
  bool isUserSelectSavedCard = false;
  var storeStripeCustomerId = '';
  var storeStripeToken = '';
  //
  @override
  void initState() {
    debugPrint('================== FEE TYPE & TITLE ==================');
    debugPrint(widget.title);
    debugPrint(widget.feeType); // generateDebitCard
    debugPrint('======================================================');
    fetchProfileData();
    super.initState();
  }

  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) {
      if (kDebugMode) {
        //  print(v);
      }
      if (kDebugMode) {
        print('=============================');
        print(STRIPE_STATUS);
        print('=============================');
      }

      if (STRIPE_STATUS == 'T') {
        storeStripeCustomerId = v['data']['stripe_customer_id_Test'];
      } else {
        storeStripeCustomerId = v['data']['stripe_customer_id_Live'];
      }
      logger.d(v);
      logger.d(storeStripeCustomerId);

      // Logger().d(storeStripeToken);
      // Logger().d(v);
    });
    getFeesAndTaxes();
  }

  @override
  void dispose() {
    super.dispose();
    contCardNumber.dispose();
    contCardExpMonth.dispose();
    contCardExpYear.dispose();
    contCardCVV.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor(appORANGEcolorHexCode),
        title: textFontPOOPINS(
          'Fees and Charges',
          Colors.black,
          16.0,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left)),
      ),
      body: screenLoader == true
          ? Center(child: textFontPOOPINS('please wait...', Colors.black, 14.0))
          : SingleChildScrollView(child: _UIKit(context)),
    );
  }

  Widget _UIKit(BuildContext context) {
    return Column(
      children: [
        // const Divider(),
        const SizedBox(height: 10.0),
        Center(
          child: textFontPOOPINS(
            '${widget.title} fees',
            Colors.black,
            20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),

        widget.feeType == 'addExternalDebitCard'
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: textFontPOOPINS(
                  'To Create a ${widget.title}, you will need to provide your card details for maintenance purpose. A "\$2" monthly maintenance fee will automatically be charged from your added card. This fee ensures your ${widget.title} remains active and up-to-date.',
                  Colors.grey,
                  12.0,
                ),
              ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              textFontPOOPINS(
                'Convenience fees:',
                Colors.black,
                16.0,
              ),
              const Spacer(),
              textFontPOOPINS(
                '\$$showConvenienceFeesOnPopup',
                Colors.black,
                12.0,
              )
            ],
          ),
        ),
        const SizedBox(height: 40.0),
        if (userSavedCard == true) ...[
          Row(
            children: [
              const SizedBox(width: 1),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    contCardNumber.text = '';
                    contCardExpMonth.text = '';
                    contCardExpYear.text = '';
                    setState(() {
                      isUserSelectSavedCard = false;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: isUserSelectSavedCard == false
                          ? hexToColor(appGREENcolorHexCode)
                          : Colors.white,
                      border: Border.all(),
                    ),
                    child: Center(
                      child: textFontPOOPINS(
                        'Enter card details',
                        isUserSelectSavedCard == true
                            ? Colors.black
                            : Colors.white,
                        14.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 1),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (userSavedCard == true) {
                      contCardNumber.text =
                          savedCardDetailsInDictionary['cardNumber'].toString();
                      contCardExpMonth.text =
                          savedCardDetailsInDictionary['cardExpMonth']
                              .toString();
                      contCardExpYear.text =
                          savedCardDetailsInDictionary['cardExpYear']
                              .toString();
                    }
                    setState(() {
                      isUserSelectSavedCard = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: isUserSelectSavedCard == false
                          ? Colors.white
                          : hexToColor(appGREENcolorHexCode),
                      border: Border.all(),
                    ),
                    child: Center(
                      child: textFontPOOPINS(
                        'Your saved cards',
                        isUserSelectSavedCard == false
                            ? Colors.black
                            : Colors.white,
                        14.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 1),
            ],
          ),
        ],
        isUserSelectSavedCard == true
            ? userSelectSavedCard(context)
            : userSelectWhicTyprCardUIKit(context)
      ],
    );
  }

  Padding userSelectWhicTyprCardUIKit(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 120,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              textFontPOOPINS(
                'Please enter your card details',
                Colors.black,
                12.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Card number',
                ),
                controller: contCardNumber,
                maxLength: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: contCardExpMonth,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Exp. month',
                      ),
                      maxLength: 2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: contCardExpYear,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Exp. year',
                      ),
                      maxLength: 2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: contCardCVV,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'CVV',
                      ),
                      maxLength: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  Checkbox(
                    value: saveCard,
                    onChanged: (bool? value) {
                      setState(() {
                        saveCard = value ?? false;
                      });
                    },
                  ),
                  saveCard == true
                      ? textFontPOOPINS(
                          'Save this card for payments',
                          Colors.black,
                          14.0,
                        )
                      : textFontPOOPINS(
                          'Save this card for payments',
                          Colors.grey,
                          14.0,
                        ),
                ],
              ),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: () {
                  matchAndVerifyAfterClickSubmit();
                  /*if (cardholderNameController.text.isNotEmpty &&
                    cardNumberController.text.length == 16 &&
                    expMonthController.text.isNotEmpty &&
                    expYearController.text.isNotEmpty &&
                    cvvController.text.length == 3) {
                  /*final cardDetails = CardDetailsForTaxAndFees(
                    cardholderName: cardholderNameController.text,
                    cardNumber: cardNumberController.text,
                    expMonth: expMonthController.text,
                    expYear: expYearController.text,
                    cvv: cvvController.text,
                    saveCard: saveCard,
                  );*/

                  /*Navigator.pop(context, {
                    'topButtonClicked': false,
                    'cardDetails': cardDetails,
                    'saveCard': saveCard
                  });*/
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields correctly.'),
                    ),
                  );
                }*/
                },
                child: const Text('Submit & Pay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding userSelectSavedCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 120,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              textFontPOOPINS(
                'Please enter your card details',
                Colors.black,
                12.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Card number',
                ),
                controller: contCardNumber,
                maxLength: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: contCardExpMonth,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Exp. month',
                      ),
                      maxLength: 2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: contCardExpYear,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Exp. year',
                      ),
                      maxLength: 2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: contCardCVV,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'CVV',
                      ),
                      maxLength: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              userSavedCard == true
                  ? const SizedBox()
                  : Row(
                      children: [
                        Checkbox(
                          value: saveCard,
                          onChanged: (bool? value) {
                            setState(() {
                              saveCard = value ?? false;
                            });
                          },
                        ),
                        saveCard == true
                            ? textFontPOOPINS(
                                'Save this card for payments',
                                Colors.black,
                                14.0,
                              )
                            : textFontPOOPINS(
                                'Save this card for payments',
                                Colors.grey,
                                14.0,
                              ),
                      ],
                    ),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: () {
                  matchAndVerifyAfterClickSubmit();
                  /*if (cardholderNameController.text.isNotEmpty &&
                    cardNumberController.text.length == 16 &&
                    expMonthController.text.isNotEmpty &&
                    expYearController.text.isNotEmpty &&
                    cvvController.text.length == 3) {
                  /*final cardDetails = CardDetailsForTaxAndFees(
                    cardholderName: cardholderNameController.text,
                    cardNumber: cardNumberController.text,
                    expMonth: expMonthController.text,
                    expYear: expYearController.text,
                    cvv: cvvController.text,
                    saveCard: saveCard,
                  );*/

                  /*Navigator.pop(context, {
                    'topButtonClicked': false,
                    'cardDetails': cardDetails,
                    'saveCard': saveCard
                  });*/
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields correctly.'),
                    ),
                  );
                }*/
                },
                child: const Text('Submit & Pay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  matchAndVerifyAfterClickSubmit() {
    if (contCardNumber.text == '') {
      return;
    }
    if (contCardExpMonth.text == '') {
      return;
    }
    if (contCardExpYear.text == '') {
      return;
    }
    if (contCardCVV.text == '') {
      return;
    }
    if (contCardNumber.text.length != 16) {
      return;
    }
    if (contCardExpMonth.text.length != 2) {
      return;
    }
    if (contCardNumber.text.length != 16) {
      return;
    }
    if (contCardExpYear.text.length != 2) {
      return;
    }
    if (contCardCVV.text.length != 3) {
      return;
    } else {
      debugPrint('Data is filled');
      if (saveCard == true) {
        debugPrint("SAVE THIS CARD AND PAY");
        final cardDetails = SavedCardDetails(
          cardNumber: contCardNumber.text.toString(),
          cardholderName: loginUserName(),
          expMonth: contCardExpMonth.text.toString(),
          expYear: contCardExpYear.text.toString(),
          cvv: contCardCVV.text.toString(),
        );
        if (kDebugMode) {
          print(cardDetails.cardNumber);
          print(loginUserName());
          print(cardDetails.expMonth);
          print(cardDetails.expYear);
          print(cardDetails.expYear);
          print(cardDetails.cvv);
        }
        // save card in firebase
        saveCardInDbAndPay(cardDetails);
      } else {
        debugPrint("DO NOT SAVE THIS CARD AND PAY");
        /* final cardDetails = SavedCardDetails(
          cardNumber: savedCardDetailsInDictionary['cardNumber'],
          cardholderName: savedCardDetailsInDictionary['cardHolderName'],
          expMonth: savedCardDetailsInDictionary['cardExpMonth'],
          expYear: savedCardDetailsInDictionary['cardExpYear'],
          cvv: contCardCVV.text.toString(),
        );
        if (kDebugMode) {
          print(cardDetails.cardNumber);
        }*/
        showLoadingUI(context, 'please wait...');
        processPayment(
          context,
          loginUserName(),
          contCardNumber.text.toString(),
          contCardExpMonth.text.toString(),
          contCardExpYear.text.toString(),
          contCardCVV.text.toString(),
          totalAmountAfterCalculateFee,
          false,
        );
      }
    }
  }

  saveCardInDbAndPay(cardDetails) async {
    showLoadingUI(context, 'please wait...');
    final card = CardModel(
      userId: loginUserId(),
      cardHolderName: loginUserName(),
      cardNumber: cardDetails.cardNumber.toString(),
      cardExpMonth: cardDetails.expMonth.toString(),
      cardExpYear: cardDetails.expYear.toString(),
      cardId: const Uuid().v4(),
      cardStatus: true,
    );
    final success = await SavedCardService.saveUserCardInRealDB(card);
    if (success) {
      debugPrint('Firebase: Card saved successfully');
      processPayment(
        context,
        loginUserName(),
        cardDetails.cardNumber,
        cardDetails.expMonth,
        cardDetails.expYear,
        cardDetails.cvv,
        totalAmountAfterCalculateFee,
        true,
      );
    } else {
      debugPrint('Failed to save card');
    }
  }

  // get charges and fees API
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
        if (fee.name == widget.feeType) {
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
        }
      }
      if (feesAndTaxesType == TAX_TYPE_PERCENTAGE) {
        String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
        showConvenienceFeesOnPopup = double.parse(formattedValue.toString());
        // FEES CALCULATOR
        calculateFeesAndReturnValue();
      } else {
        String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
        showConvenienceFeesOnPopup = double.parse(formattedValue.toString());
        fetchAndCheckSavedCard(context);
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
      print('TOTAL AMOUNT IS: ======> $totalAmountAfterCalculateFee');
      print('CONVENIENCE FEES IS: ==> $showConvenienceFeesOnPopup');
    }
    // API
    fetchAndCheckSavedCard(context);
  }

  // call saved card details
  Future<void> fetchAndCheckSavedCard(BuildContext context) async {
    final savedCardDetails = await getUserSavedCardDetails(loginUserId());

    if (savedCardDetails != false) {
      savedCardDetailsInDictionary = savedCardDetails;
      debugPrint('====================================');
      debugPrint('YES, USER SAVED A CARD');
      debugPrint('====================================');
      userSavedCard = true;

      setState(() {
        screenLoader = false;
      });
      // Timer(const Duration(milliseconds: 300), handleTimeout);
    } else {
      debugPrint('====================================');
      debugPrint('No, Card is saved in Firebase');
      debugPrint('====================================');
      userSavedCard = false;
      setState(() {
        screenLoader = false;
      });
    }
  }

  // pay
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
      // print('Stripe amount to send: $amount');
      // print('Stripe amount to send: $cardSavedStatus');
    }
    storeStripeToken = token.toString();

    logger.d(storeStripeToken);

    chargeMoneyFromStripeAndAddToEvsServer(
      amount,
      token,
      cardSavedStatus,
      number.toString(),
      month.toString(),
      year.toString(),
      cvv.toString(),
    );
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

        // debugPrint(widget.feeType); //
/*
widget.feeType == 'addExternalDebitCard'
            ? 
            */
        if (widget.feeType.toString() == 'generateDebitCard') {
          logger.d('====> GENERATE CARD AND START SUBSCRIPTION <====');
          if (storeStripeCustomerId == '') {
            logger.d('NO STRIPE CUSTOMER CREATED');
            _registerCustomerInStripe(
              number,
              month,
              year,
              cvv,
            );
          } else {
            logger.d('Yes, Stripe customer is already created.');
            createStripeCustomerAccount(storeStripeCustomerId);
          }
        }
        if (widget.feeType.toString() == 'addExternalDebitCard') {
          debugPrint('==> ADD EXTERNAL DEBIT CARD');
          sucessEverythingNowGoBack();
        } else {
          // NOE CREATE A UNIT BANK ACCOUNT
          sucessEverythingNowGoBack();
        }
      }
    } else {
      Navigator.pop(context);
    }
  }

  void _registerCustomerInStripe(
    number,
    month,
    year,
    cvv,
  ) async {
    debugPrint('API ==> REGISTER CUSTOMER IN STRIPE 3');
    //
    // showLoadingUI(context, 'please wait...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();

    final newStripeToken = await createStripeToken(
        cardNumber: number.toString(),
        expMonth: month.toString(),
        expYear: year.toString(),
        cvc: cvv.toString());

    // Use the token for further processing, such as making a payment
    logger.d(newStripeToken);

    final parameters = {
      'action': 'customer',
      'userId': userId,
      'name': loginUserName(),
      'email': loginUserEmail(),
      'tokenID': newStripeToken.toString()
    };
    if (kDebugMode) {
      print(parameters);
    }

    try {
      final response = await _apiService2.stripePostRequest(parameters, token);
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
          createStripeCustomerAccount(customerId);
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

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
            logger.d('SUCCESS: SUBSCRIPTION');
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

  sucessEverythingNowGoBack() {
    Navigator.pop(context);
    Navigator.pop(context, REFRESH_CONVENIENCE_FEES);
  }
}
