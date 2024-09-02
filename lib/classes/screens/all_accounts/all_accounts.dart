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
            areYourSureCreateAccountPopup(
              context,
              totalAmountAfterCalculateFee,
            );
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
    bool result = await CreateAccountService.createAccount(customerID);
    setState(() {
      accountCreated = result;
    });

    // Print the result to check it
    if (result) {
      debugPrint('Account created successfully.');
      successCreated();
    } else {
      debugPrint('Failed to create account.');
    }
  }

  successCreated() {
    removePopLoader = true;
    totalAmountAfterCalculateFee != 0.0
        ? const SizedBox()
        : Navigator.pop(context);
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
              ? Navigator.pop(context)
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
}
