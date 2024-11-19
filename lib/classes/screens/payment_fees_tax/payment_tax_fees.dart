import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/model/model.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/save_get_card.dart';
import 'package:ride_card_app/classes/screens/convenience_fee/convenience_fees.dart';
import 'package:ride_card_app/classes/screens/success/success.dart';
import 'package:ride_card_app/classes/service/charge_money_from_stripe/charge_money_from_stripe.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PaymentTaxAndFeesScreen extends StatefulWidget {
  const PaymentTaxAndFeesScreen(
      {super.key, this.cardData, this.receiverData, required this.getAmount});

  final String getAmount;
  final cardData;
  final receiverData;

  @override
  State<PaymentTaxAndFeesScreen> createState() =>
      _PaymentTaxAndFeesScreenState();
}

class _PaymentTaxAndFeesScreenState extends State<PaymentTaxAndFeesScreen> {
  //
  final stripeService = ChargeMoneyStripeService();
  final ApiService _apiService = ApiService();
  final GenerateTokenService _apiServiceGT = GenerateTokenService();
  bool screenLoader = true;
  String feesAndTaxesType = '';
  double feesAndTaxesAmount = 0.0;
  double calculatedFeeAmount = 0.0;
  double totalAmountAfterCalculateFee = 0.0;
  bool removePopLoader = false;
  double showConvenienceFeesOnPopup = 0.0;
  var savedCardDetailsInDictionary;
  var _totalAmountIs = 0.0;
  //
  @override
  void initState() {
    if (kDebugMode) {
      print('=====================');
      print(widget.cardData);
      print(widget.receiverData);
      print('=====================');
    }
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
        if (fee.name == 'walletToWalletFee') {
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

        addAmountAndConveinceFee();
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
    addAmountAndConveinceFee();
  }

  addAmountAndConveinceFee() {
    if (kDebugMode) {
      print('============================');
      print('Amount: ${widget.getAmount}');
      print('Convenience fees: $showConvenienceFeesOnPopup');
    }
    var amountForAdd = double.parse(widget.getAmount.toString());
    var convForAdd = double.parse(showConvenienceFeesOnPopup.toString());
    var addBoth = amountForAdd + 0; ////convForAdd;
    _totalAmountIs = addBoth;

    setState(() {
      screenLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor(appORANGEcolorHexCode),
        leading: IconButton(
          onPressed: () {
            //
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
        ),
        title: textFontPOOPINS(
          'Invoice',
          Colors.black,
          16.0,
        ),
      ),
      body: screenLoader == true ? const SizedBox() : _UIKit(),
    );
  }

  Column _UIKit() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 16.0,
              ),
              child: textFontPOOPINS(
                // sd
                'Receiver Info',
                Colors.black,
                18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            children: [
              textFontPOOPINS(
                // sd
                'Name',
                Colors.black,
                14.0,
              ),
              const Spacer(),
              textFontPOOPINS(
                // sd
                widget.receiverData['userName'],
                Colors.black,
                12.0,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        const Divider(thickness: 0.4),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            children: [
              textFontPOOPINS(
                // sd
                'Email:',
                Colors.black,
                14.0,
              ),
              const Spacer(),
              textFontPOOPINS(
                // sd
                widget.receiverData['email'],
                Colors.black,
                12.0,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        const Divider(thickness: 0.4),

        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            children: [
              textFontPOOPINS(
                // sd
                'Phone:',
                Colors.black,
                14.0,
              ),
              const Spacer(),
              textFontPOOPINS(
                // sd
                widget.receiverData['usercontactNumber'],
                Colors.black,
                12.0,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),

        const Divider(thickness: 0.4),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 16.0,
              ),
              child: textFontPOOPINS(
                // sd
                'Payment Info',
                Colors.black,
                18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            children: [
              textFontPOOPINS(
                // sd
                'Sending Amount:',
                Colors.black,
                14.0,
              ),
              const Spacer(),
              textFontPOOPINS(
                // sd
                '\$${widget.getAmount}',
                Colors.black,
                12.0,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        const Divider(thickness: 0.4),
        /*Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            children: [
              textFontPOOPINS(
                // sd
                'Convenience fees:',
                Colors.black,
                14.0,
              ),
              const Spacer(),
              textFontPOOPINS(
                // sd
                '\$$showConvenienceFeesOnPopup',
                Colors.black,
                12.0,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        const Divider(thickness: 0.4),*/
        /*const SizedBox(height: 40.0),
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
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    40.0,
                  ),
                  child: Image.network(
                    // sd
                    widget.receiverData['profile_picture'],
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              title: textFontPOOPINS(
                // sd
                widget.receiverData['userName'],
                Colors.black,
                18.0,
              ),
              subtitle: textFontPOOPINS(
                // sd
                widget.receiverData['usercontactNumber'],
                Colors.grey,
                12.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40.0),
        textFontPOOPINS('To', Colors.grey, 12.0),
        const SizedBox(height: 40.0),
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
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    40.0,
                  ),
                  child: Image.network(
                    // sd
                    widget.receiverData['profile_picture'],
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              title: textFontPOOPINS(
                // sd
                widget.receiverData['userName'],
                Colors.black,
                18.0,
              ),
              subtitle: textFontPOOPINS(
                // sd
                widget.receiverData['usercontactNumber'],
                Colors.grey,
                12.0,
              ),
            ),
          ),
        ),*/
        const Spacer(),
        const Divider(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 16.0,
              ),
              child: textFontPOOPINS(
                // sd
                'Total:',
                Colors.black,
                18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 16.0,
              ),
              child: textFontPOOPINS(
                // sd
                '\$$_totalAmountIs',
                Colors.black,
                16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12.0),
        const Divider(),
        /*Padding(
          padding: const EdgeInsets.all(8.0),
          child: textFontPOOPINS(
            '\$${widget.getAmount} will be deducted from your wallet directly and \$$showConvenienceFeesOnPopup is conveinence fee and it will be deducted from your card.',
            Colors.grey,
            10.0,
          ),
        ),*/
        GestureDetector(
          onTap: () {
            //
            HapticFeedback.mediumImpact();
            debugPrint('===========================');
            debugPrint('Pay and Send button clicked');
            debugPrint('===========================');
            // openCardBottomSheet(context);
            pushToConvenienceFeeScreen(context);
          },
          child: Container(
            height: 60,
            // width: 120,
            decoration: BoxDecoration(
              color: hexToColor(appORANGEcolorHexCode),
            ),
            child: Center(
              child: textFontPOOPINS(
                ' Pay and Send ',
                Colors.black,
                16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        // Container(hei)
      ],
    );
  }

// TAXES AND FEES
  /*void getFeesAndTaxes(userSelectType) async {
    ApiServiceToGetFeesAndTaxes apiService = ApiServiceToGetFeesAndTaxes();

    List<FeeData>? feeList = await apiService.fetchFeesAndTaxes();

    if (feeList != null) {
      for (var fee in feeList) {
        if (kDebugMode) {
          print(
            'ID: ${fee.id}, Name: ${fee.name}, Type: ${fee.type}, Amount: ${fee.amount}',
          );
        }
        if (fee.name == userSelectType) {
          // account closing
          debugPrint('===========================');
          debugPrint('====> $userSelectType <====');
          debugPrint('===========================');
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
        // FEES CALCULATOR
        calculateFeesAndReturnValue();
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
    //
    Navigator.pop(context);
    if (strWhatUserSelect == 'close_bank_account') {
      areYourSurecloseAccountPopup(context, showConvenienceFeesOnPopup);
    } else if (strWhatUserSelect == 'unfreeze_bank_account') {
      areYourSureUnfreezeAccountPopup(context, showConvenienceFeesOnPopup);
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
      Timer(const Duration(milliseconds: 300), handleTimeout);
    } else {
      debugPrint('No card is saved in Firebase');
    }
  }

  // ALL ENTERED OR SAVED CARD DETAILS RETURN
  Future<void> processCardPayment(BuildContext context,
      CardDetailsForTaxAndFees cardDetails, bool saveCard) async {
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
        debugPrint('======================================');
        debugPrint('DO MAIN FUNCTION HERE AFTER EVERYTHING');
        debugPrint('======================================');
      }
    } else {
      Navigator.pop(context);
    }
  }

  void _sendMoney(
    context,
    String receiverId,
    // status,
    String type,
  ) async {
    debugPrint('API ==> SEND MONEY');

    showLoadingUI(context, 'sending...');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters;
    var deductAmountWithCommision =
        double.parse(widget.getAmount.toString()) - double.parse('0.13');
    parameters = {
      'action': 'sendmoney',
      'senderId': userId,
      'userId': receiverId, // receiverId
      'amount': deductAmountWithCommision.toString(),
      'type': type,
      'admincharge': '0',
      // '0.13',
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
            roleIs,
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click api
            _sendMoney(
              context,
              receiverId,
              'Sent',
            );
          });
          //
        } else {
          //
          if (successStatus == 'Fail') {
            Navigator.pop(context);
            dismissKeyboard(context);
            // Navigator.pop(context);
            customToast(
              successMessage,
              hexToColor(appORANGEcolorHexCode),
              ToastGravity.BOTTOM,
            );
          } else {
            Navigator.pop(context);
            pushToSuccess(context, jsonResponse);
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
      Navigator.pop(context);
      customToast(
        'Something went wrong with server. Please try again after sometime.',
        Colors.red,
        ToastGravity.TOP,
      );
    }
  }

  Future<void> pushToSuccess(BuildContext context, responseData) async {
    //
    dismissKeyboard(context);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessScreen(
          receiverData: widget.receiverData,
          responseData: responseData,
          amount: widget.getAmount,
          showButton: true,
          status: '0',
        ),
      ),
    );

    if (!mounted) return;
    //
    if (result == 'reload_screen') {
      if (kDebugMode) {
        print(result);
      }
      getFeesAndTaxes();
    }
  }

  Future<void> pushToConvenienceFeeScreen(BuildContext context) async {
    //
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ConvenienceFeesChargesScreen(
            title: 'Send money',
            feeType: 'walletToWalletFee',
          ),
        ));

    if (!mounted) return;
    //
    if (result == REFRESH_CONVENIENCE_FEES) {
      if (kDebugMode) {
        print(result);
      }
      _sendMoney(
        context,
        widget.receiverData['userId'].toString(),
        'Sent',
      );
    }
  }
}
