import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/StripeAPIs/bank_details.dart';
import 'package:ride_card_app/classes/StripeAPIs/check_account_balance.dart';
import 'package:ride_card_app/classes/StripeAPIs/get_connected_bank_balance.dart';
import 'package:ride_card_app/classes/StripeAPIs/payout_pay.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/get_price.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/model/model.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/service/UNIT/CUSTOMER/get_customer_accounts_list/get_customer_account_list.dart';
import 'package:ride_card_app/classes/service/UNIT/send_to_client/send_to_client.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final ApiService _apiService2 = ApiService();
  final GenerateTokenService _apiServiceGT = GenerateTokenService();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController contEnterAmount = TextEditingController();
  final TextEditingController contYourBankAccount = TextEditingController();
  var customerID = '';
  var selectedAccountId = '';
  List<dynamic>? accountDetails;
  bool screenLoader = true;
  String balanceIs = '';
  var showLoader = '0';
  String amountToSendToCustomer = '';
  // double amountSend = 0.0;
  double amountSendToClientMainBnkAccount = 0.0;
  double amountSendToCustomerBankAccount = 0.0;
  String amountInpercentageToShow = '';
  //

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
  String storeDocumentId = '';
  String storeBankAccountId = '';
  @override
  void initState() {
    // fetchAndDisplayStripeBalance(context);
    getAllDocumentsData();

    super.initState();
  }

  Future<List<Map<String, dynamic>>> getAllDocumentsData() async {
    List<Map<String, dynamic>> allDocumentsData = [];
    await FirebaseFirestore.instance
        .collection('RIDE_WALLET/STRIPE_CONNECT_ACCOUNTS/BANK_ACCOUNTS')
        .where('userId', isEqualTo: loginUserId())
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Loop through each document in the snapshot
        for (var document in snapshot.docs) {
          if (kDebugMode) {
            print("Document ID: ${document.id}");
          }

          // Retrieve all data inside the document
          Map<String, dynamic> data = document.data();
          logger.d(data);
          storeDocumentId = document.id;
          storeBankAccountId = data['accountId'].toString();
          logger.d(storeBankAccountId);
          contYourBankAccount.text = data['bankAccountNumber'].toString();
          fetchProfileData();
        }
      } else {
        if (kDebugMode) {
          print("No documents found for the user.");
        }
        setState(() {
          screenLoader = false;
        });
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to retrieve data: $error");
      }
    });

    // Return the list of all document data
    return allDocumentsData;
  }

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
        child: screenLoader == true
            ? const SizedBox()
            : _UIKitCardsAfterBG(context),
      ),
    );
  }

  Widget _UIKitCardsAfterBG(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 80.0),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 16.0,
                    ),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    child: const Icon(
                      Icons.menu,
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
                    'Withdraw money',
                    Colors.white,
                    18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 40.0),
          textFontPOOPINS(
            'Wallet balance: \$$balanceIs',
            Colors.white,
            18.0,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10.0),
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
                  readOnly: false,
                  controller: contEnterAmount,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    hintText: 'Enter amount',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10.0,
                    ),
                    /*suffixIcon: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: svgImage(
                      'email',
                      14.0,
                      14.0,
                    ),
                  ),*/
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
          const SizedBox(height: 10.0),
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
                  readOnly: true,
                  controller: contYourBankAccount,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Select your bank account',
                    border: InputBorder.none, // Remove the border
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10.0,
                    ),
                    /*suffixIcon: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: svgImage(
                      'email',
                      14.0,
                      14.0,
                    ),
                  ),*/
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                  ),
                  /*onTap: () {
                    _showAccountSelectionSheet(context);

                    // Open the bottom sheet when tapped
                  },*/
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return TEXT_FIELD_EMPTY_TEXT;
                    }
                    return null;
                  },*/
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
            child: GestureDetector(
              onTap: () async {
                //  print(double.parse(contEnterAmount.text.toString()));
                // print(double.parse(balanceIs.toString()));
                if (_formKey.currentState!.validate()) {
                  if (double.parse(contEnterAmount.text.toString()) >
                      double.parse(balanceIs.toString())) {
                    logger.d("You don't have enough money in your wallet.");
                    dismissKeyboard(context);
                    customToast(
                      'Entered amount should be less then wallet amount.',
                      Colors.redAccent,
                      ToastGravity.BOTTOM,
                    );
                  } else {
                    dismissKeyboard(context);
                    showLoader = '1';
                    showLoadingUI(context, 'please wait...');
                    /*logger.d(dotenv.env['UNIT_BANK_ID'].toString());
                    logger.d(selectedAccountId.toString());*/
                    /*final amount = convertDollarsToCentsAsString(
                        contEnterAmount.text.toString());
                    logger.d(amount.toString());

                    // amountToSend = amount;

                    // logger.d(amountToSend);

                    // first send payment to client as convenience fees

                    getFeesAndTaxes();*/
                    payoutAndPay();
                  }
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
                    'Withdraw',
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

  void payoutAndPay() async {
    fetchAndDisplayStripeBalance(context);
  }

  void fetchAndDisplayStripeBalance(BuildContext context) async {
    final balanceData = await getStripeBalanceAPI();

    if (balanceData != null) {
      final availableBalance = balanceData['available'][0]['amount'];
      final currency = balanceData['available'][0]['currency'];

      logger.d(availableBalance);
      // }

      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Available Balance: ${(availableBalance / 100).toStringAsFixed(2)} $currency'),
        ),
      );*/
      logger.d(
          'Available Balance: ${(availableBalance / 100).toStringAsFixed(2)} $currency');
      if (availableBalance == 0 || availableBalance == 0.0) {
        customToast(
          'Something went wrong. Please contact admin.',
          Colors.redAccent,
          ToastGravity.BOTTOM,
        );
        Navigator.pop(context);
      } else {
        String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
        double payoutAmount = double.parse(contEnterAmount.text.toString());
        final int amountInSmallestUnit = (payoutAmount * 100).toInt();
        logger.d(amountInSmallestUnit);
        // const amount = amountInSmallestUnit;
        const currency = 'usd';
        String connectedAccountId = storeBankAccountId;

        // Step 1: Transfer funds to the connected Stripe account
        await createTransfer(
          amount: amountInSmallestUnit,
          currency: currency,
          connectedAccountId: connectedAccountId,
          stripeSecretKey: apiKey,
        );

        // Step 2: Payout funds to the user's external bank account
        await createPayout(
          amount: amountInSmallestUnit,
          currency: currency,
          connectedAccountId: connectedAccountId,
          stripeSecretKey: apiKey,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to retrieve Stripe balance.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        if (fee.name == 'instantDeposit') {
          if (fee.type == TAX_TYPE_PERCENTAGE) {
            feesAndTaxesType = fee.type.toString();
            feesAndTaxesAmount = double.parse(fee.amount.toString());
            amountInpercentageToShow = fee.amount.toString();
            /*showConvenienceFeesOnPopup = (feesAndTaxesAmount * 10) / 100;
            totalAmountAfterCalculateFee = (feesAndTaxesAmount * 10) / 100;
            // amount send to customer
            amountSend = double.parse(contEnterAmount.text.toString()) -
                showConvenienceFeesOnPopup;*/
          } else {
            debugPrint(fee.type);
            feesAndTaxesType = fee.type.toString();
            feesAndTaxesAmount = double.parse(fee.amount.toString());
            showConvenienceFeesOnPopup = feesAndTaxesAmount;
            totalAmountAfterCalculateFee = feesAndTaxesAmount;
            amountInpercentageToShow = fee.amount.toString();
            // amount send to customer
            /*amountSend = double.parse(contEnterAmount.text.toString()) -
                showConvenienceFeesOnPopup;*/
          }
        }
      }
      if (feesAndTaxesType == TAX_TYPE_PERCENTAGE) {
        double calculatedFeeAfterTax = feesAndTaxesAmount / 100;
        String formattedValue = calculatedFeeAfterTax.toStringAsFixed(3);

        double fee = double.parse(formattedValue);

        // first
        // calculate customer amount
        double calculateCustomerAmountAfterFeeGet =
            double.parse(contEnterAmount.text.toString()) - fee;
        String formattedValueForCustomerAmount =
            calculateCustomerAmountAfterFeeGet.toStringAsFixed(2);
        //
        amountSendToCustomerBankAccount =
            double.parse(formattedValueForCustomerAmount);

        String formattedValueForClientAmount = fee.toStringAsFixed(3);
        amountSendToClientMainBnkAccount =
            double.parse(formattedValueForClientAmount);
        logger.d("Customer total amount: $amountSendToCustomerBankAccount");
        logger.d("Client total amount: $amountSendToClientMainBnkAccount");

        Navigator.pop(context);
        showTransferBottomSheet(context, fee.toString());
        //
        // not working
        // initiatePayment(context, showConvenienceFeesOnPopup, selectedAccountId);
      } else {
        String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
        showConvenienceFeesOnPopup = double.parse(formattedValue.toString());
        logger.d(showConvenienceFeesOnPopup);

        //
        double calculateFixAmount =
            double.parse(contEnterAmount.text) - feesAndTaxesAmount;
        logger.d(calculateFixAmount);
        //
        //
        String formattedValue22 = calculateFixAmount.toStringAsFixed(2);
        amountSendToCustomerBankAccount = double.parse(formattedValue22);
        amountSendToClientMainBnkAccount = feesAndTaxesAmount;
        // logger.d("Customer total amount: $amountSendToCustomerBankAccount");
        // logger.d("Client total amount: $amountSendToClientMainBnkAccount");
        //
        //
        Navigator.pop(context);
        showTransferBottomSheet(context, feesAndTaxesAmount.toString());
        //
        // not working
        // initiatePayment(context, showConvenienceFeesOnPopup, selectedAccountId);
      }
    } else {
      if (kDebugMode) {
        print('Failed to retrieve fee data.');
      }
    }
  }

  void showTransferBottomSheet(
    BuildContext context,
    String feeAmount,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              textFontPOOPINS(
                "We charge  \$$amountInpercentageToShow fee to instantly transfer money from your wallet to your bank account. Do you wish to proceed?\n\nYou will receive \$$amountSendToCustomerBankAccount in your selected bank account.",
                Colors.black,
                14.0,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Handle transfer action
                  Navigator.pop(context);
                  initiatePayment(
                    context,
                    showConvenienceFeesOnPopup,
                    selectedAccountId,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 16.0,
                  ),
                ),
                child: const Text(
                  'Transfer',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //

  void initiatePayment(
    BuildContext context,
    double amount,
    String selectedAccountId,
  ) async {
    showLoadingUI(context, 'please wait...');
    // Call the sendPayment function
    logger.d(amount);

    // send full amount to customer from Z account
    sendPayment();
  }

  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) {
      logger.d(v);
      customerID = v['data']['customerId'].toString();
      balanceIs = v['data']['wallet'].toString();
      logger.d('Balance is: ==> $balanceIs');
      // fetchAccountDetails();
      getBankAccountInfo(storeBankAccountId);
      setState(() {
        screenLoader = false;
      });
    });
  }

  void getBankAccountInfo(String bankAccountId) async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
    final bankAccountDetails = await getConnectedAccountBalance(
      storeBankAccountId,
      apiKey,
    );

    if (bankAccountDetails != null) {
      if (kDebugMode) {
        print(bankAccountDetails);
        /*print('Bank Name: ${bankAccountDetails['bank_name']}');
        print(
            'Account Holder Name: ${bankAccountDetails['account_holder_name']}');
        print('Routing Number: ${bankAccountDetails['routing_number']}');
        print(
            'Last 4 Digits of Account Number: ${bankAccountDetails['last4']}');*/
      }

      // You can display this information in your UI as needed
    } else {
      if (kDebugMode) {
        print('Failed to retrieve bank account details.');
      }
    }
  }

  Future<void> fetchAccountDetails() async {
    accountDetails = await GetAllUnitAccountsService
        .getParticularAccountDetailsViaCustomerId(customerID);
    logger.d(accountDetails?[0]);
    if (kDebugMode) {
      print(storeBankAccountId);
    }
    if (showLoader == '1') {
      showLoader = '0';
      Navigator.pop(context);
    }
    setState(() {
      screenLoader = false;
    });
  }

  void _showAccountSelectionSheet(BuildContext context) {
    // Parse the JSON response

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 500,
          child: ListView.builder(
            itemCount: accountDetails?.length,
            itemBuilder: (context, index) {
              final account = accountDetails?[index];
              final accountNumber = account['attributes']['accountNumber'];
              final accountId = account['id'];

              return Column(
                children: [
                  ListTile(
                    leading: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        'assets/images/bank.png',
                      ),
                    ),
                    title: textFontOPENSANS(
                      accountNumber,
                      Colors.black,
                      16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    onTap: () {
                      // Store the selected account ID
                      setState(
                        () {
                          contYourBankAccount.text = accountNumber.toString();
                          selectedAccountId = accountId;
                        },
                      );

                      // Dismiss the bottom sheet
                      Navigator.pop(context);

                      // Optionally, show a confirmation message
                      /*ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected Account ID: $selectedAccountId'),
                        ),
                      );*/
                    },
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> sendPayment() async {
    final url = Uri.parse('https://api.s.unit.sh/payments');
    final headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };
    // logger.d(amountSend);
    // logger.d(amountSend * 100);
    double convert = (amountSendToCustomerBankAccount * 100);
    String formattedValue = convert.toStringAsFixed(2);
    // logger.d(formattedValue);
    int myInt = double.parse(formattedValue.toString()).round();
    //
    if (kDebugMode) {
      print(amountSendToCustomerBankAccount * 100);
    }
    //
    // return;
    // String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
    final body = jsonEncode({
      "data": {
        "type": "bookPayment",
        "attributes": {
          "amount": myInt,
          "description": "Withdraw ( wallet )",
        },
        "relationships": {
          "account": {
            "data": {
              "type": "depositAccount",
              "id": dotenv.env['UNIT_BANK_ID'].toString()
            }
          },
          "counterpartyAccount": {
            "data": {
              "type": "depositAccount",
              "id": selectedAccountId.toString(),
            }
          }
        }
      }
    });
    logger.d(body);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Payment succeeded
        if (kDebugMode) {
          print('Payment successful: ${response.body}');
        }
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        String status = jsonData['data']['attributes']['status'];
        // String reason = jsonData['data']['attributes']['reason'];
        if (status == 'Rejected') {
          Navigator.pop(context);
          dismissKeyboard(context);
          customToast(
            'Please contact admin.',
            Colors.redAccent,
            ToastGravity.BOTTOM,
          );
        } else {
          logger.d('Done payment');

          bool paymentSuccess = await sendPaymentToClientAccount(
            amount: amountSendToClientMainBnkAccount,
            // showConvenienceFeesOnPopup,
            selectedAccountId: selectedAccountId,
            context: context,
          );

          // Handle the response
          if (paymentSuccess) {
            // Payment was successful
            debugPrint('Payment was successful');
            editWalletBalance(context);
          } else {
            // Payment failed
            customToast(
              'Payment failed. Please try again.',
              Colors.redAccent,
              ToastGravity.BOTTOM,
            );
          }
        }
      } else {
        // Payment failed
        if (kDebugMode) {
          print('Failed to send payment: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred: $error');
      }
    }
  }

  void editWalletBalance(
    context,
  ) async {
    debugPrint('API ==> EDIT PROFILE');
    // String parseDevice = await deviceIs();

    var amount = double.parse(balanceIs.toString()) -
        double.parse(contEnterAmount.text.toString());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {
      'action': 'editProfile',
      'userId': userId,
      'wallet': amount.toString(),
    };
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
            loginUserEmail(),
            roleIs.toString(),
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            editWalletBalance(
              context,
            );
          });
        } else {
          //
          contYourBankAccount.text = "";
          contEnterAmount.text = "";
          dismissKeyboard(context);

          customToast(
            'Transaction completed.',
            Colors.green,
            ToastGravity.BOTTOM,
          );

          fetchProfileData();
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }
}
