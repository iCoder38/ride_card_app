import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_card_app/classes/StripeAPIs/accept_terms.dart';
import 'package:ride_card_app/classes/StripeAPIs/all_banks.dart';
import 'package:ride_card_app/classes/StripeAPIs/bank_details.dart';
import 'package:ride_card_app/classes/StripeAPIs/check_account_balance.dart';
import 'package:ride_card_app/classes/StripeAPIs/check_account_requirements.dart';
import 'package:ride_card_app/classes/StripeAPIs/create_customer.dart';
import 'package:ride_card_app/classes/StripeAPIs/get_connected_bank_balance.dart';
import 'package:ride_card_app/classes/StripeAPIs/link_bank_account.dart';
import 'package:ride_card_app/classes/StripeAPIs/update_account_info.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/bank/add.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllBanksScreen extends StatefulWidget {
  const AllBanksScreen({super.key});

  @override
  State<AllBanksScreen> createState() => _AllBanksScreenState();
}

class _AllBanksScreenState extends State<AllBanksScreen> {
  var screenLoader = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  var arrBanks = [];
  //
  var storeStripeCustomerId = '';
  @override
  void initState() {
    // fetchProfileData();
    // checkBalance();
    super.initState();
  }

  void checkBalance() async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
    String connectedAccountId = "acct_1QJykvERnsh89gxe";

    final balanceData =
        await getConnectedAccountBalance(connectedAccountId, apiKey);

    if (balanceData != null) {
      print("Connected Account Balance:");
      print("Available:");
      for (var balance in balanceData['available']) {
        print(balance);
        print(" - Amount: ${balance['amount']} ${balance['currency']}");
      }
      print("Pending:");
      for (var balance in balanceData['pending']) {
        print(" - Amount: ${balance['amount']} ${balance['currency']}");
      }
    } else {
      print("Failed to retrieve the balance.");
    }
  }

  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) async {
      logger.d(v);
      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      prefs2.setString(
          'Key_save_login_profile_picture', v['data']['image'].toString());
      prefs2.setString('key_save_user_role', v['data']['role'].toString());

      if (STRIPE_STATUS == 'T') {
        logger.d('Mode: Test');
        if (v["stripe_customer_id_Test"].toString() == '') {
          createCustomerInStripe(
            '${v["data"]["fullName"]} ${v["data"]["lastName"]}',
            v["data"]["email"].toString(),
          );
        }
      } else {
        logger.d('Mode: Live');
        if (v["data"]["stripe_customer_id_Live"].toString() == '') {
          createCustomerInStripe(
            '${v["data"]["fullName"]} ${v["data"]["lastName"]}',
            v["data"]["email"].toString(),
          );
        } else {
          storeStripeCustomerId =
              v["data"]["stripe_customer_id_Live"].toString();
          fetchAndDisplayBankAccounts();
        }
      }
    });
  }

  // create customer in stripe
  void createCustomerInStripe(
    String name,
    String email,
  ) async {
    final customerId = await createStripeCustomerAPI(
      name: name,
      email: email,
    );

    if (customerId != null) {
      if (kDebugMode) {
        print('Customer created successfully with ID: $customerId');
      }
      storeStripeCustomerId = customerId.toString();
      editAfterCreateStripeCustomer(context, customerId);
    } else {
      if (kDebugMode) {
        print('Failed to create customer.');
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
          logger.d("Stripe customer created successfully");
          fetchAndDisplayBankAccounts();
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  void fetchAndDisplayBankAccounts() async {
    /*final bankAccounts = await getCustomerBankAccountsAPI(
      storeStripeCustomerId,
    );

    if (bankAccounts != null) {
      // Display bank accounts in the UI
      for (var account in bankAccounts) {
        if (kDebugMode) {
          print(account);
          print('Bank Account ID: ${account['id']}');
          print('Bank Name: ${account['bank_name']}');
          print('Last 4 Digits: ${account['last4']}');
        }
        var custom = {
          'bankId': account['id'],
          'bankLast4Digits': account['last4'],
          'verified': account['status']
        };
        arrBanks.add(custom);
      }
      setState(() {
        screenLoader = false;
      });
    } else {
      // Show an error message if retrieval failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to retrieve bank accounts.'),
          backgroundColor: Colors.red,
        ),
      );
    }*/
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
      child: screenLoader == true
          ? customCircularProgressIndicator()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: _UIKitStackBG(context),
            ),
    );
  }

  SingleChildScrollView _UIKitStackBG(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: screenLoader == true
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //
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
                      Expanded(
                        child: Container(
                          height: 40,
                          color: Colors.transparent,
                          child: Center(
                            child: textFontORBITRON(
                              //
                              'Bank accounts',
                              Colors.white,
                              14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            pushToAddBankAccount(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 16.0,
                            ),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  for (int i = 0; i < arrBanks.length; i++) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: ListTile(
                        title: textFontPOOPINS(
                          "Bank account number",
                          Colors.black,
                          14.0,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: textFontPOOPINS(
                          "**** **** ${arrBanks[i]['bankLast4Digits']}",
                          Colors.black,
                          12.0,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (arrBanks[i]['verified'].toString() ==
                                'verified') ...[
                              IconButton(
                                onPressed: () {
                                  customToast(
                                    'Verified.',
                                    Colors.green,
                                    ToastGravity.BOTTOM,
                                  );
                                },
                                icon: const Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                ),
                              ),
                            ] else ...[
                              IconButton(
                                onPressed: () {
                                  customToast(
                                    'This account is not verified.',
                                    Colors.redAccent,
                                    ToastGravity.BOTTOM,
                                  );
                                },
                                icon: const Icon(Icons.info_outline),
                              ),
                            ]
                          ],
                        ),
                        onTap: () {
                          // getBankAccountInfo(arrBanks[i]['bankId'].toString());
                          // fetchAndDisplayStripeBalance(context);
                          acceptTerms('acct_1QJykvERnsh89gxe');
                          // transferMoney();
                        },
                      ),
                    )
                  ]
                ],
              ),
            ),
    );
  }

  void fetchAndDisplayStripeBalance(BuildContext context) async {
    final balanceData = await getStripeBalanceAPI();

    if (balanceData != null) {
      final availableBalance = balanceData['available'][0]['amount'];
      final currency = balanceData['available'][0]['currency'];

      print(availableBalance);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Available Balance: ${(availableBalance / 100).toStringAsFixed(2)} $currency'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to retrieve Stripe balance.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void getBankAccountInfo(String bankAccountId) async {
    final bankAccountDetails = await getBankAccountDetailsAPI(
      storeStripeCustomerId,
      bankAccountId,
    );

    if (bankAccountDetails != null) {
      if (kDebugMode) {
        print(bankAccountDetails);
        print('Bank Name: ${bankAccountDetails['bank_name']}');
        print(
            'Account Holder Name: ${bankAccountDetails['account_holder_name']}');
        print('Routing Number: ${bankAccountDetails['routing_number']}');
        print(
            'Last 4 Digits of Account Number: ${bankAccountDetails['last4']}');
      }

      // You can display this information in your UI as needed
    } else {
      print('Failed to retrieve bank account details.');
    }
  }

  void acceptTerms(String bankId) async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
    String connectedAccountId = bankId;
    logger.d(connectedAccountId);
    int acceptanceDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String acceptanceIp = "8.8.8.8";

    bool isAccepted = await acceptTermsOfService(
      connectedAccountId: connectedAccountId,
      apiKey: apiKey,
      acceptanceDate: acceptanceDate,
      acceptanceIp: acceptanceIp,
    );

    if (isAccepted) {
      print("Terms of Service accepted successfully.");
      checkRequirements(connectedAccountId);
      // updateRequirements(connectedAccountId);
    } else {
      print("Failed to accept Terms of Service.");
    }
  }

  void checkRequirements(String bankId) async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
    String connectedAccountId = bankId;

    try {
      List<String> requirements = await getAccountRequirements(
        connectedAccountId,
        apiKey,
      );
      print("Account requirements: $requirements");
      print(requirements.length);
      if (requirements.isEmpty) {
        transferMoney(connectedAccountId);
      }
      // transferMoney

      // Based on the requirements, display input fields to the user for each required item.
      for (var requirement in requirements) {
        print("Please provide: $requirement");

        // Add your UI code here to handle each requirement
      }
    } catch (e) {
      print("Failed to get account requirements: $e");
    }
  }

  void updateRequirements(String bankId) async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
    String connectedAccountId = bankId;

    String businessUrl = "https://thebluebamboo.in";
    String statementDescriptor = "My Statement";

    bool isUpdated = await updateAccountInformation(
      connectedAccountId,
      apiKey,
      businessUrl: businessUrl,
      statementDescriptor: statementDescriptor,
    );

    if (isUpdated) {
      print("Account information updated successfully.");
      checkRequirements(bankId);
    } else {
      print("Failed to update account information.");
    }
  }

  void transferMoney(String bankId) async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;

    logger.d(loginUserEmail);
    logger.d(bankId);
    await manageConnectedAccount(
      userId: bankId,
      userEmail: loginUserEmail(),
      accountNumber: "000123456789",
      country: "US",
      currency: "usd",
      accountHolderName: loginUserName(),
      accountHolderType: "individual",
      transferAmount: 1000,
      routingNumber: "110000000",
    );

    // Step 1: Create a connected account for the user
    /*final connectedAccountId = await createConnectedAccount(
      loginUserEmail(),
      apiKey,
    );
    if (connectedAccountId == null) {
      print('Failed to create connected account.');
      return;
    }

    // Step 2: Link the user's bank account
    final bankAccountToken = await createBankAccountToken(
      accountNumber: '000123456789',
      country: 'US',
      currency: 'usd',
      accountHolderName: loginUserName(),
      accountHolderType: 'individual',
      routingNumber: '110000000',
      apiKey: apiKey,
    );

    if (bankAccountToken != null) {
      final isLinked = await linkBankAccountToConnectedAccount(
        // connectedAccountId,
        'acct_1QJyaWCadelSXGXM',
        bankAccountToken,
        apiKey,
      );

      if (!isLinked) {
        print('Failed to link bank account.');
        return;
      }
    } else {
      print('Failed to create bank account token.');
      return;
    }

    // Step 3: Transfer funds to the connected account
    final isTransferred = await transferFundsToConnectedAccount(
      connectedAccountId,
      1000, // Transfer amount in cents, e.g., 1000 for $10.00
      apiKey,
    );

    if (!isTransferred) {
      print('Failed to transfer funds.');
      return;
    }

    // Step 4: Initiate payout to the user's bank account
    final isPaidOut = await payoutToBankAccount(
      connectedAccountId,
      1000, // Payout amount in cents
      apiKey,
    );

    if (isPaidOut) {
      print('Payout successful!');
    } else {
      print('Failed to payout.');
    }*/
  }

  Future<void> pushToAddBankAccount(
    BuildContext context,
  ) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddBankScreen(),
      ),
    );

    if (!mounted) return;
    //
    if (result == 'refresh') {
      arrBanks.clear();
      fetchProfileData();
    }
  }
}
