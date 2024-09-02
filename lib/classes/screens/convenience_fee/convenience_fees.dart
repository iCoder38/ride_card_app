import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/stripe/generate_token/generate_token.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/fee_calculator/fee_calculator.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/get_price.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/model/model.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/model/model.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/save_get_card.dart';
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
  final TextEditingController contCardNumber = TextEditingController();
  final TextEditingController contCardExpMonth = TextEditingController();
  final TextEditingController contCardExpYear = TextEditingController();
  final TextEditingController contCardCVV = TextEditingController();

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
  //
  @override
  void initState() {
    debugPrint('================== FEE TYPE & TITLE ==================');
    debugPrint(widget.title);
    debugPrint(widget.feeType);
    debugPrint('======================================================');
    getFeesAndTaxes();
    super.initState();
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
        const SizedBox(height: 40.0),
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
                child: const Text('Submit'),
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
                child: const Text('Submit'),
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
    showloading(context, 'Please wait...');
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
          ToastGravit.BOTTOM,
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
        // _createUnitBankAccount(context);
      }
    } else {
      Navigator.pop(context);
    }
  }
}
