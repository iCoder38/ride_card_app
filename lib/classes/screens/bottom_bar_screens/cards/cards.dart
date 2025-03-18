import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/StripeAPIs/create_customer.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/widgets/widgets.dart';
import 'package:ride_card_app/classes/service/UNIT/checkWalletStatus/check_wallet_status.dart';
import 'package:ride_card_app/classes/service/UNIT/create_bank/create.dart';
import 'package:ride_card_app/classes/service/check_cc_score/check_cc_score.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String data = 'Fetching data...';

  final CheckUnitWalletStatus _walletStatusChecker = CheckUnitWalletStatus();

  final ApiService _apiService = ApiService();
  final GenerateTokenService _apiServiceGT = GenerateTokenService();
  GenerateTokenService apiServiceGT = GenerateTokenService();

  final TextEditingController _contPanSnn = TextEditingController();
  String yourScore = '';

  final String clientId =
      'kcPZGZqmj4dlsuGdkQ75uBQxLEGIQhCL'; // Replace with your actual client ID
  final String baseUrl =
      'https://api.equifax.com/personal/consumer-data-suite/v1/creditReport'; // Replace with the actual Equifax API endpoint
  String creditScore = 'Fetching credit score...';
  //
  bool screenLoader = true;
  var showCCPanel = '';
  var storeStripeCustomerId = 'cus_RCGgHxJvbMHQzB';
  //
  // String TESTING_TOKEN =
  //     'v2.public.eyJyb2xlIjoiYWRtaW4iLCJ1c2VySWQiOiI3NTY3Iiwic3ViIjoianVzdGluYmVubmV0dEByaWRlYXBwaW5jZ2xvYmFsLmNvbSIsImV4cCI6IjIwMjQtMDgtMjZUMTI6NDM6NTguNzA1WiIsImp0aSI6IjMzMDY2NSIsIm9yZ0lkIjoiNDIxOSIsInNjb3BlIjoiYXBwbGljYXRpb25zIGFwcGxpY2F0aW9ucy13cml0ZSBjdXN0b21lcnMgY3VzdG9tZXJzLXdyaXRlIGN1c3RvbWVyLXRhZ3Mtd3JpdGUgY3VzdG9tZXItdG9rZW4td3JpdGUgYWNjb3VudHMgYWNjb3VudHMtd3JpdGUgY2FyZHMgY2FyZHMtd3JpdGUgY2FyZHMtc2Vuc2l0aXZlIHRyYW5zYWN0aW9ucyB0cmFuc2FjdGlvbnMtd3JpdGUgYXV0aG9yaXphdGlvbnMgc3RhdGVtZW50cyBwYXltZW50cyBwYXltZW50cy13cml0ZSBwYXltZW50cy13cml0ZS1jb3VudGVycGFydHkgcGF5bWVudHMtd3JpdGUtbGlua2VkLWFjY291bnQgYWNoLXBheW1lbnRzLXdyaXRlIHdpcmUtcGF5bWVudHMtd3JpdGUgcmVwYXltZW50cyByZXBheW1lbnRzLXdyaXRlIHBheW1lbnRzLXdyaXRlLWFjaC1kZWJpdCBjb3VudGVycGFydGllcyBiYXRjaC1yZWxlYXNlcyBiYXRjaC1yZWxlYXNlcy13cml0ZSBsaW5rZWQtYWNjb3VudHMgd2ViaG9va3Mgd2ViaG9va3Mtd3JpdGUgZXZlbnRzIGV2ZW50cy13cml0ZSBhdXRob3JpemF0aW9uLXJlcXVlc3RzIGF1dGhvcml6YXRpb24tcmVxdWVzdHMtd3JpdGUgY2FzaC1kZXBvc2l0cyBjYXNoLWRlcG9zaXRzLXdyaXRlIGNoZWNrLWRlcG9zaXRzIGNoZWNrLWRlcG9zaXRzLXdyaXRlIHJlY2VpdmVkLXBheW1lbnRzIHJlY2VpdmVkLXBheW1lbnRzLXdyaXRlIGRpc3B1dGVzIGNoYXJnZWJhY2tzIHJld2FyZHMgcmV3YXJkcy13cml0ZSBjaGVjay1wYXltZW50cyBjaGVjay1wYXltZW50cy13cml0ZSBjcmVkaXQtZGVjaXNpb25zIGxlbmRpbmctcHJvZ3JhbXMgY3JlZGl0LWFwcGxpY2F0aW9ucyBjcmVkaXQtYXBwbGljYXRpb25zLXdyaXRlIG1pZ3JhdGlvbnMgbWlncmF0aW9ucy13cml0ZSIsIm9yZyI6IlJpZGUgYXBwIGluYyIsInNvdXJjZUlwIjoiIiwidXNlclR5cGUiOiJvcmciLCJpc1VuaXRQaWxvdCI6ZmFsc2V9oPEe4b0t2NMYJM38ZXvYzwKpPxoQK1NbYAsnOSMI-Ut2I8YBF2gDkIaCoN7Ua6LO8WVauqrCD_LhXoRqJeqIBw';

  // 'v2.public.eyJyb2xlIjoiYWRtaW4iLCJ1c2VySWQiOiI3NTY3Iiwic3ViIjoianVzdGluYmVubmV0dEByaWRlYXBwaW5jZ2xvYmFsLmNvbSIsImV4cCI6IjIwMjQtMDUtMjhUMTE6MjE6MjkuNDU3WiIsImp0aSI6IjMzMDMzMyIsIm9yZ0lkIjoiNDIxOSIsInNjb3BlIjoiYXBwbGljYXRpb25zLXdyaXRlIGFjY291bnRzLXdyaXRlIGNhcmRzLXdyaXRlIiwib3JnIjoiUmlkZSBhcHAgaW5jIiwidXNlclR5cGUiOiJvcmciLCJpc1VuaXRQaWxvdCI6ZmFsc2V9kiWoE7oOsoWIlEdFIRhA8AiM3qT2lUkalqrIxCCpIbyMP7uU5s86OIk8S4IddsvsgWqJ63E_RCOijna8JE7PCQ';

  /*
  
  */
  @override
  void initState() {
    showCCPanelFunc(context);
    //
    // editWalletBalance(context);
    super.initState();
  }

  void editWalletBalance(
    context,
  ) async {
    debugPrint('API ==> EDIT PROFILE');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {
      'action': 'editProfile',
      'userId': userId,
      'wallet': '3.50'.toString(),
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
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            editWalletBalance(context);
          });
        } else {
          dismissKeyboard(context);

          customToast(
            'Successfully transferred.',
            Colors.green,
            ToastGravity.BOTTOM,
          );

          // fetchProfileData();
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  showCCPanelFunc(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showCCPanel = prefs.getString('key_show_cc_panel').toString();
    /*if (kDebugMode) {
      print('panel ==> $showCCPanel');
    }*/
    if (showCCPanel == 'yes') {
      //
      prefs.remove('key_show_cc_panel');
      showLoadingUI(context, PLEASE_WAIT);
      _sendRequestToProfile(context);
    }
    fetchProfileData();
    // addBankAccount('Rajputana');
  }

  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) async {
      logger.d(v);
      if (v == null) {
        // logger.d('Hit again');
        fetchProfileData();
      } else {
        SharedPreferences prefs2 = await SharedPreferences.getInstance();
        prefs2.setString(
            'Key_save_login_profile_picture', v['data']['image'].toString());
        prefs2.setString('key_save_user_role', v['data']['role'].toString());

        if (STRIPE_STATUS == 'T') {
          // logger.d('Mode: Test');
          if (v["stripe_customer_id_Test"].toString() == '') {
            /* createCustomerInStripe(
            '${v["data"]["fullName"]} ${v["data"]["lastName"]}',
            v["data"]["email"].toString(),
          );*/
          }
        } else {
          // logger.d('Mode: Live');
          if (v["data"]["stripe_customer_id_Live"].toString() == '') {
            // logger.d('No, Stripe customer account.');
            createCustomerInStripe(
              '${v["data"]["fullName"]} ${v["data"]["lastName"]}',
              v["data"]["email"].toString(),
            );
          } else {
            storeStripeCustomerId =
                v["data"]["stripe_customer_id_Live"].toString();
            setState(() {
              screenLoader = false;
            });
          }
          // addBankAccount('${v["data"]["fullName"]} ${v["data"]["lastName"]}');
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
      editAfterCreateStripeCustomer(context, customerId);
    } else {
      if (kDebugMode) {
        print('Failed to create customer.');
      }
    }
  }

  /*Future<void> addBankAccount(String accountHolderName) async {
    try {
      final bankAccountToken = await createBankAccountTokenAPI(
        accountNumber: '000123456789',
        country: 'US',
        currency: 'usd',
        accountHolderName: accountHolderName,
        accountHolderType: 'individual',
        routingNumber: '110000000',
      );
      logger.d(storeStripeCustomerId);
      if (bankAccountToken != null && storeStripeCustomerId.isNotEmpty) {
        final response = await attachBankAccountToCustomerAPI(
          customerId: storeStripeCustomerId,
          bankAccountToken: bankAccountToken,
        );

        if (response.statusCode == 200) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bank account added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Parse the error message
          final responseData = json.decode(response.body);
          final errorMessage = responseData['error']?['message'] ??
              'Failed to add bank account. Please try again.';

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle case where token creation fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create bank account token.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show error if an exception occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }*/

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
          logger.d("Stripe customer created successfully");
          // createStripeCustomerAccount(customerId);
          showCCPanelFunc(context);
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  payout() async {
    http.Response response = await createPayout('ba_1PzgVlCc4YwUErYBOqcNTfjl');

    // Handle the response (e.g., show a success or failure message)
    if (response.statusCode == 200) {
      // Success case
      if (kDebugMode) {
        print('Payout successful: ${response.body}');
      }
      // You can also show a snackbar or alert to the user
    } else {
      // Failure case
      if (kDebugMode) {
        print('Payout failed: ${response.body}');
      }
    }
  }

  Future<void> createCustomer() async {
    // Replace with the customer's email
    /*String? customerId = await createStripeCustomer('purnimaevs@gmail.com');

    if (customerId != null) {
      if (kDebugMode) {
        print('Stripe customer created successfully: $customerId');
      }
    } else {
      if (kDebugMode) {
        print('Failed to create Stripe customer.');
      }
    }*/
  }

  attachBankAccountWithCustomerId() {
    /*final addBankResponse = attachBankAccountToCustomer(
      'cus_QrPRXhqZC28tsQ',
      'btok_1PzgVlCc4YwUErYBvILqyyLj',
    );

    if (kDebugMode) {
      print(addBankResponse);
      logger.d(addBankResponse);
    }*/
  }

  checkIsUserHaveAWallet(customerId) async {
    logger.d('CHECKING WALLET STATUS with CUSTOMER ID: $customerId');

    try {
      final response = await _walletStatusChecker.checkWalletStatus(customerId);
      // final response = await _walletStatusChecker.getWalletAccount(customerId);

      // Process response here
      if (response.statusCode == 200) {
        // Parse and handle the response
        final responseBody = response.body;
        if (kDebugMode) {
          print('Wallet created successfully: $responseBody');
        }
      } else {
        // Handle failure case
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Handle any exceptions
      if (kDebugMode) {
        print('Exception: $e');
      }
    }
    /*final checkWakketResponse = CheckUnitWalletStatus().checkWalletStatus(
      customerId,
    );

    logger.d(checkWakketResponse);*/
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
    return Column(
      children: [
        const SizedBox(
          height: 80.0,
        ),
        customNavigationBarForMenu(
          TEXT_NAVIGATION_TITLE_DASHBOARD,
          _scaffoldKey,
        ),
        //
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 140,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 240, 240, 240),
              borderRadius: BorderRadius.circular(
                16.0,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 4.0,
                ),
                textFontORBITRON(
                  //
                  TEXT_CREDIT_SCORE,
                  Colors.black,
                  22.0,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                textFontPOOPINS(
                  'Check your current credit score.',
                  const Color.fromARGB(255, 96, 95, 95),
                  14.0,
                  fontWeight: FontWeight.w400,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 24.0, left: 24.0),
                  child: Divider(),
                ),
                GestureDetector(
                  onTap: () {
                    showLoadingUI(context, PLEASE_WAIT);
                    _sendRequestToProfile(context);
                  },
                  child: yourScore != ''
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textFontPOOPINS(
                              'Your score is: ',
                              const Color.fromARGB(255, 121, 120, 120),
                              14.0,
                            ),
                            textFontPOOPINS(
                              yourScore,
                              Colors.black,
                              18.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ],
                        )
                      : textFontPOOPINS(
                          'Check score now >',
                          appREDcolor,
                          14.0,
                          fontWeight: FontWeight.w800,
                        ),
                ),
              ],
            ),
          ),
        ),
        //
        widgetDashboardUpperDeck(context),
        const SizedBox(
          height: 20.0,
        ),
        widgetDashbaordLowerDeck(context),

        Padding(
          padding: const EdgeInsets.all(22.0),
          child: GestureDetector(
            onTap: () async {
              //
              if (kDebugMode) {
                print('object');
              }
              // await getCustomerById('1983432');
              // checkCustomerAccounts('1983432');
              // fetchDummyData1();
              // _createCustomer();
              // getOrganizations();
              // getApplications();
              // createAccount();
              // await createAccount();
              // getAllTotalAccounts();
              // getParticularAccountDetails();
              // getParticularAccountDetailsViaCustomerId();
              // checkMyDepositBankAccountLimit();
              // createCustomer();
              /*apiServiceGT
                  .generateToken(
                '52',
                'test03@gmail.com',
                'Member',
              )
                  .then((v) {
                //
                if (kDebugMode) {
                  print('TOKEN ==> $v');
                }
                // again click
              });*/
              // getUserFullDataToSendNotification('nILM0K6h3pWHweAhKcI5cZDTGky1');
              // openLink();
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  14.0,
                ),
                border: Border.all(
                  color: appREDcolor,
                  width: 2.0,
                ),
              ), // 218 71 50
              child: Center(
                child: textFontPOOPINS(
                  //
                  'Apply Ride Debit Card',
                  Colors.white,
                  18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 22.0,
            right: 22.0,
          ),
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const RegisterScreen()),
              // );
              openLink();
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(
                  234,
                  158,
                  70,
                  1,
                ),
                borderRadius: BorderRadius.circular(
                  14.0,
                ),
              ), // 218 71 50
              child: Center(
                child: textFontPOOPINS(
                  //
                  'Get a ride',
                  Colors.white,
                  18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void openLink() async {
    String androidLink =
        "https://play.google.com/store/apps/details?id=ridemobility.app";
    String iosLink = "https://apps.apple.com/lt/app/id1619072901";
    // Determine the link based on the platform
    final String link = Platform.isAndroid ? androidLink : iosLink;

    // Try launching the URL
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }
  /*Future<void> fetchCreditScore() async {
    print('object 2 ');
    try {
      // Call Equifax service to fetch credit score
      double score = await equifaxService.fetchCreditScore();
      setState(() {
        creditScore = 'Your credit score is: $score';
      });
    } catch (e) {
      setState(() {
        creditScore = 'Failed to fetch credit score: $e';
      });
    }
  }*/

  /*Future<void> fetchData2() async {
    try {
      Map<String, dynamic> result = await equifaxService.fetchEquifaxData();
      setState(() {
        data = result.toString();
      });
    } catch (e) {
      setState(() {
        data = 'Error: $e';
      });
    }
  }*/
// kcPZGZqmj4dlsuGdkQ75uBQxLEGIQhCL
  // void fetchCreditScore() async {
  //   fetchCreditScore2(
  //     apiUrl: CC_SCORE_BASE_URL,
  //     clientId: CC_SCORE_CLIENT_ID,
  //     clientSecret: CC_SCORE_CLIENT_SECRET,
  //     moduleSecret: CC_SCORE_MODULE_SECRET,
  //     providerSecret: CC_SCORE_PROVIDER_SECRET,
  //     name: "BICKY KUMAR",
  //     mobile: "9555536396",
  //     inquiryPurpose: "CC",
  //     documentType: "PAN",
  //     documentId: "AAICV0413H",
  //   ).then((v) {
  //     //
  //     if (kDebugMode) {
  //       print('=====> $v');
  //     }
  //   });
  // }

  void _sendRequestToProfile(context) async {
    debugPrint('API ==> PROFILE');
    var name = '';
    var contactNumner = '';
    // var box = await Hive.openBox<MyData>(HIVE_BOX_KEY);
    // var myData = box.getAt(0);
    // await box.close();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString('key_save_token_locally'));
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();

    // print(prefs.getString('key_save_token_locally'));
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {'action': 'profile', 'userId': userId};
    if (kDebugMode) {
      print(parameters);
    }
    // return;
    try {
      final response = await _apiService.postRequest(parameters, '');
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];

      if (response.statusCode == 200) {
        debugPrint('PROFILE: RESPONSE ==> SUCCESS');
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
            _sendRequestToProfile(context);
          });
        } else {
          //
          debugPrint('SUCCESS');
          var first_name = jsonResponse['data']['fullName'];
          var last_name = jsonResponse['data']['lastName'];
          name = first_name + ' ' + last_name;
          contactNumner = jsonResponse['data']['contactNumber'];
          Navigator.pop(context);
          checkCreditScorePopUpSheet(
            context,
            'message',
            'content',
            name,
            contactNumner,
          );
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('PROFILE: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  void checkCreditScorePopUpSheet(
    BuildContext context,
    String message,
    content,
    String name,
    String contactNumber,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: textFontPOOPINS(
                              'Please check your info and enter your pan/ssn before proceeding.',
                              Colors.black,
                              14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(width: 20.0),
                          textFontPOOPINS(
                            'Name: ',
                            Colors.black,
                            14.0,
                          ),
                          textFontPOOPINS(
                            name,
                            Colors.grey,
                            14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(width: 20.0),
                          textFontPOOPINS(
                            'Mobile: ',
                            Colors.black,
                            14.0,
                          ),
                          textFontPOOPINS(
                            //
                            contactNumber,
                            Colors.grey,
                            14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 22.0,
                      ),
                      textFontPOOPINS(
                        'PAN/SSN',
                        Colors.black,
                        12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextFormField(
                          controller: _contPanSnn,
                          decoration: const InputDecoration(
                            hintText: 'pan/ssn',
                            border: InputBorder.none, // Remove the border
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 10.0,
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pop();
                      //
                      showLoadingUI(context, CHECKING_SCORE_TEXT);
                      //
                      fetchCreditScore2(
                        apiUrl:
                            'https://in.staging.decentro.tech/v2/financial_services/credit_bureau/credit_report/summary',

                        // dotenv.env['CC_SCORE_BASE_URL'] ?? 'default_key',
                        clientId:
                            dotenv.env['CC_SCORE_CLIENT_ID'] ?? 'default_key',
                        clientSecret: dotenv.env['CC_SCORE_CLIENT_SECRET'] ??
                            'default_key',
                        moduleSecret: dotenv.env['CC_SCORE_MODULE_SECRET'] ??
                            'default_key',
                        providerSecret:
                            dotenv.env['CC_SCORE_PROVIDER_SECRET'] ??
                                'default_key',
                        name: name, //"BICKY KUMAR",
                        mobile: contactNumber, //"9555536396",
                        inquiryPurpose: "CC",
                        documentType: "PAN",
                        documentId: _contPanSnn.text.toString().toUpperCase(),
                      ).then((v) {
                        //
                        if (kDebugMode) {
                          print('CC CHECK SCORE =====> $v');
                          // print(v['status'].runtimeType);
                        }
                        if (v['status'] == null) {
                          debugPrint('am i null');
                        }
                        if (v['status'].toString() == 'FAILURE') {
                          //
                          if (kDebugMode) {
                            print('FAIL');
                          }
                          customToast(
                            v['message'],
                            Colors.redAccent,
                            ToastGravity.BOTTOM,
                          );
                          Navigator.pop(context);
                          Navigator.of(context).pop();
                        } else {
                          if (v['status'].toString() == 'SUCCESS') {
                            debugPrint('SUCCESSFULLY GET');
                            List<dynamic> scoreDetails = v['data']
                                    ['cCRResponse']['cIRReportDataLst'][0]
                                ['cIRReportData']['scoreDetails'];
                            if (kDebugMode) {
                              print(scoreDetails.length);
                            }
                            String name = scoreDetails[0]['value'].toString();
                            Navigator.pop(context);
                            Navigator.of(context).pop();
                            //
                            customToast(
                              'Success',
                              Colors.green,
                              ToastGravity.BOTTOM,
                            );
                            setState(() {
                              yourScore = name;
                            });
                          } else {
                            customToast('Consumer not found.', Colors.redAccent,
                                ToastGravity.BOTTOM);
                            Navigator.pop(context);
                          }
                          /*String errorDesc = v['data']['cCRResponse']
                                      ['cIRReportDataLst'][0]['error']
                                  ['errorDesc'] ??
                              'N.A.';
                          if (kDebugMode) {
                            print(errorDesc);
                          }*/
                          // if (errorDesc == 'Consumer not found in bureau') {
                          //   customToast('Consumer not found.', Colors.redAccent,
                          //       ToastGravity.BOTTOM);
                          //   Navigator.pop(context);
                          // } else {}
                        }
                      });
                      //
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: textFontORBITRON(
                          'Check',
                          Colors.black,
                          18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: textFontPOOPINS(
                          'Dismiss',
                          Colors.red,
                          14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /*Future<void> fetchDummyData1() async {
    final url =
        Uri.parse('https://api.s.unit.sh/customers'); // get all customer
    // final url = Uri.parse(
    // 'https://api.s.unit.sh/cards'); // create individual debit cards

    var token =
        'v2.public.eyJyb2xlIjoiYWRtaW4iLCJ1c2VySWQiOiI3NTY3Iiwic3ViIjoianVzdGluYmVubmV0dEByaWRlYXBwaW5jZ2xvYmFsLmNvbSIsImV4cCI6IjIwMjQtMDgtMjZUMTI6NDM6NTguNzA1WiIsImp0aSI6IjMzMDY2NSIsIm9yZ0lkIjoiNDIxOSIsInNjb3BlIjoiYXBwbGljYXRpb25zIGFwcGxpY2F0aW9ucy13cml0ZSBjdXN0b21lcnMgY3VzdG9tZXJzLXdyaXRlIGN1c3RvbWVyLXRhZ3Mtd3JpdGUgY3VzdG9tZXItdG9rZW4td3JpdGUgYWNjb3VudHMgYWNjb3VudHMtd3JpdGUgY2FyZHMgY2FyZHMtd3JpdGUgY2FyZHMtc2Vuc2l0aXZlIHRyYW5zYWN0aW9ucyB0cmFuc2FjdGlvbnMtd3JpdGUgYXV0aG9yaXphdGlvbnMgc3RhdGVtZW50cyBwYXltZW50cyBwYXltZW50cy13cml0ZSBwYXltZW50cy13cml0ZS1jb3VudGVycGFydHkgcGF5bWVudHMtd3JpdGUtbGlua2VkLWFjY291bnQgYWNoLXBheW1lbnRzLXdyaXRlIHdpcmUtcGF5bWVudHMtd3JpdGUgcmVwYXltZW50cyByZXBheW1lbnRzLXdyaXRlIHBheW1lbnRzLXdyaXRlLWFjaC1kZWJpdCBjb3VudGVycGFydGllcyBiYXRjaC1yZWxlYXNlcyBiYXRjaC1yZWxlYXNlcy13cml0ZSBsaW5rZWQtYWNjb3VudHMgd2ViaG9va3Mgd2ViaG9va3Mtd3JpdGUgZXZlbnRzIGV2ZW50cy13cml0ZSBhdXRob3JpemF0aW9uLXJlcXVlc3RzIGF1dGhvcml6YXRpb24tcmVxdWVzdHMtd3JpdGUgY2FzaC1kZXBvc2l0cyBjYXNoLWRlcG9zaXRzLXdyaXRlIGNoZWNrLWRlcG9zaXRzIGNoZWNrLWRlcG9zaXRzLXdyaXRlIHJlY2VpdmVkLXBheW1lbnRzIHJlY2VpdmVkLXBheW1lbnRzLXdyaXRlIGRpc3B1dGVzIGNoYXJnZWJhY2tzIHJld2FyZHMgcmV3YXJkcy13cml0ZSBjaGVjay1wYXltZW50cyBjaGVjay1wYXltZW50cy13cml0ZSBjcmVkaXQtZGVjaXNpb25zIGxlbmRpbmctcHJvZ3JhbXMgY3JlZGl0LWFwcGxpY2F0aW9ucyBjcmVkaXQtYXBwbGljYXRpb25zLXdyaXRlIG1pZ3JhdGlvbnMgbWlncmF0aW9ucy13cml0ZSIsIm9yZyI6IlJpZGUgYXBwIGluYyIsInNvdXJjZUlwIjoiIiwidXNlclR5cGUiOiJvcmciLCJpc1VuaXRQaWxvdCI6ZmFsc2V9oPEe4b0t2NMYJM38ZXvYzwKpPxoQK1NbYAsnOSMI-Ut2I8YBF2gDkIaCoN7Ua6LO8WVauqrCD_LhXoRqJeqIBw';
    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);
        print(jsonData);
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      print('Error: $error');
    }
  }*/

  /*Future<void> getCustomerById(customerId) async {
    final url = Uri.parse(
        'https://api.s.unit.sh/customers/$customerId'); // get all customer

    var token =
        'v2.public.eyJyb2xlIjoiYWRtaW4iLCJ1c2VySWQiOiI3NTY3Iiwic3ViIjoianVzdGluYmVubmV0dEByaWRlYXBwaW5jZ2xvYmFsLmNvbSIsImV4cCI6IjIwMjQtMDgtMjZUMTI6NDM6NTguNzA1WiIsImp0aSI6IjMzMDY2NSIsIm9yZ0lkIjoiNDIxOSIsInNjb3BlIjoiYXBwbGljYXRpb25zIGFwcGxpY2F0aW9ucy13cml0ZSBjdXN0b21lcnMgY3VzdG9tZXJzLXdyaXRlIGN1c3RvbWVyLXRhZ3Mtd3JpdGUgY3VzdG9tZXItdG9rZW4td3JpdGUgYWNjb3VudHMgYWNjb3VudHMtd3JpdGUgY2FyZHMgY2FyZHMtd3JpdGUgY2FyZHMtc2Vuc2l0aXZlIHRyYW5zYWN0aW9ucyB0cmFuc2FjdGlvbnMtd3JpdGUgYXV0aG9yaXphdGlvbnMgc3RhdGVtZW50cyBwYXltZW50cyBwYXltZW50cy13cml0ZSBwYXltZW50cy13cml0ZS1jb3VudGVycGFydHkgcGF5bWVudHMtd3JpdGUtbGlua2VkLWFjY291bnQgYWNoLXBheW1lbnRzLXdyaXRlIHdpcmUtcGF5bWVudHMtd3JpdGUgcmVwYXltZW50cyByZXBheW1lbnRzLXdyaXRlIHBheW1lbnRzLXdyaXRlLWFjaC1kZWJpdCBjb3VudGVycGFydGllcyBiYXRjaC1yZWxlYXNlcyBiYXRjaC1yZWxlYXNlcy13cml0ZSBsaW5rZWQtYWNjb3VudHMgd2ViaG9va3Mgd2ViaG9va3Mtd3JpdGUgZXZlbnRzIGV2ZW50cy13cml0ZSBhdXRob3JpemF0aW9uLXJlcXVlc3RzIGF1dGhvcml6YXRpb24tcmVxdWVzdHMtd3JpdGUgY2FzaC1kZXBvc2l0cyBjYXNoLWRlcG9zaXRzLXdyaXRlIGNoZWNrLWRlcG9zaXRzIGNoZWNrLWRlcG9zaXRzLXdyaXRlIHJlY2VpdmVkLXBheW1lbnRzIHJlY2VpdmVkLXBheW1lbnRzLXdyaXRlIGRpc3B1dGVzIGNoYXJnZWJhY2tzIHJld2FyZHMgcmV3YXJkcy13cml0ZSBjaGVjay1wYXltZW50cyBjaGVjay1wYXltZW50cy13cml0ZSBjcmVkaXQtZGVjaXNpb25zIGxlbmRpbmctcHJvZ3JhbXMgY3JlZGl0LWFwcGxpY2F0aW9ucyBjcmVkaXQtYXBwbGljYXRpb25zLXdyaXRlIG1pZ3JhdGlvbnMgbWlncmF0aW9ucy13cml0ZSIsIm9yZyI6IlJpZGUgYXBwIGluYyIsInNvdXJjZUlwIjoiIiwidXNlclR5cGUiOiJvcmciLCJpc1VuaXRQaWxvdCI6ZmFsc2V9oPEe4b0t2NMYJM38ZXvYzwKpPxoQK1NbYAsnOSMI-Ut2I8YBF2gDkIaCoN7Ua6LO8WVauqrCD_LhXoRqJeqIBw';
    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
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

        updateCustomerData(jsonData['data']['id'].toString());
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print(jsonData);
        }
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }*/

  void updateCustomerData(customerId) async {
    debugPrint('====> UPDATE CUSTOMER DATA');

    String baseUrl = 'https://api.s.unit.sh/customers/$customerId';
    final Uri url = Uri.parse(baseUrl);

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    // Complete payload with updated names and contact details
    Map<String, dynamic> body = {
      "data": {
        "type": "individualCustomer",
        "attributes": {
          "address": {
            "street": "Plot 39",
            "street2": null,
            "city": "Springboro",
            "state": "OH",
            "postalCode": "45066",
            "country": "US"
          },
          "email": "david.cook@mymail.com", // Updated email
          "phone": {
            "countryCode": "91",
            "number": "7023223090",
          },
          "authorizedUsers": [
            {
              "fullName": {
                "first": "Dishant",
                "last": "Rajput",
              },
              "email": "dishant.rajput@evirtualservices.com",
              "phone": {
                "countryCode": "91",
                "number": "8287632340",
              }
            }
          ]
        }
      }
    };

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);
        debugPrint('=========== UPDATE CUSTOMER RESPONSE ==================');
        if (kDebugMode) {
          print(jsonData);
          debugPrint('=======================================================');
        }

        //  _individualDebitCard();
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print(jsonData);
        }
        // If the server returns an error response, throw an exception
        throw Exception('Failed to update data');
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  void _individualDebitCard() async {
    debugPrint('====> UPDATE CUSTOMER DATA');

    const String baseUrl = 'https://api.s.unit.sh/cards';
    final Uri url = Uri.parse(baseUrl);

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    Map<String, dynamic> body = {
      "data": {
        "type": "individualVirtualDebitCard",
        "attributes": {
          /*"shippingAddress": {
            "street": "5230 Newell Rd",
            "street2": null,
            "city": "Palo Alto",
            "state": "CA",
            "postalCode": "94303",
            "country": "US"
          },*/
          "idempotencyKey": const Uuid().v4(),
          "limits": {
            "dailyWithdrawal": 50000,
            "dailyPurchase": 50000,
            "monthlyWithdrawal": 500000,
            "monthlyPurchase": 700000
          },
        },
        "relationships": {
          "account": {
            "data": {
              "type": "depositAccount",
              "id": "3386065",
            }
          }
        }
      }
    };
    if (kDebugMode) {
      print(body);
    }

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print(jsonData);
        }
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print(jsonData);
        }
        // If the server returns an error response, throw an exception
        throw Exception('Failed to update data');
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  Future<void> getCustomerToken() async {
    if (kDebugMode) {
      print('customerToken');
    }
    // final url = Uri.parse('https://api.s.unit.sh/customers/1983432/token');
    final url = Uri.parse('https://api.s.unit.sh/customers/:customerId');

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    // Define the request body
    Map<String, dynamic> requestBody = {
      "data": {
        "type": "customerToken",
        "attributes": {"scope": "customers accounts"},
      }
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print(jsonData);
        }
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to GET CUSTOMER TOKEN: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  Future<void> getAllTotalAccounts() async {
    const String baseUrl = 'https://api.s.unit.sh/accounts/';
    final Uri url = Uri.parse(baseUrl);

    // Define custom headers
    Map<String, String> headers = {
      //'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);
        List accounts = jsonData['data'];
        debugPrint('===================');
        if (kDebugMode) {
          print(accounts.length);
          print(accounts);
          debugPrint('===================');
        }

        if (accounts.isEmpty) {
          if (kDebugMode) {
            print('THERE IS NO ACCOUNT ADDED YET');
          }
        } else {
          if (kDebugMode) {
            print('Customer has existing accounts: $accounts');
          }
        }
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print('Error fetching accounts: $jsonData');
        }
        throw Exception('Failed to fetch customer accounts');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  Future<void> getParticularAccountDetails() async {
    const String accountId = '3393356';
    const String baseUrl = 'https://api.s.unit.sh/accounts/$accountId';
    final Uri url = Uri.parse(baseUrl);

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);

        // Access account details from the jsonData map
        var account = jsonData['data'];
        if (account == null || account.isEmpty) {
          if (kDebugMode) {
            print('THERE IS NO ACCOUNT DATA AVAILABLE');
          }
        } else {
          if (kDebugMode) {
            debugPrint('===================');
            print('Account details: $account');
            debugPrint('===================');
          }
        }
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print('Error fetching account: $jsonData');
        }
        throw Exception('Failed to fetch account details');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  //

  Future<void> checkMyDepositBankAccountLimit() async {
    const String accountId = '3393356';
    const String baseUrl = 'https://api.s.unit.sh/accounts/$accountId/limits';
    final Uri url = Uri.parse(baseUrl);

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);

        // Access account details from the jsonData map
        var account = jsonData['data'];
        if (account == null || account.isEmpty) {
          if (kDebugMode) {
            print('THERE IS NO ACCOUNT DATA AVAILABLE');
          }
        } else {
          if (kDebugMode) {
            debugPrint('===================');
            print('Account details: $account');
            debugPrint('===================');
          }
        }
      } else {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print('Error fetching account: $jsonData');
        }
        throw Exception('Failed to fetch account details');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  //
  /*
{"data":{"type":"individualApplication","attributes":{"ssn":"279254399","fullName":{"first":"Justin","last":"Hardin"},"dateOfBirth":"1962-05-03","address":{"street":"60 Canal St.","city":"La Crosse","state":"WI","postalCode":"54601","country":"US"},"email":"justin.hardin@mymail.com","phone":{"countryCode":"1","number":"6609870860"},"occupation":"Doctor","tags":{"test":"webhook-tag","key":"another-tag","number":"111"}}}}
  */

  /*void _createCustomer() async {
    Map<String, dynamic> customerData = {
      'fullName': {
        'first': 'Dishant',
        'last': 'Rajput',
      },
      'email': 'dishantrajput2020@gmail.com',
      'phone': {
        'countryCode': '91',
        'number': '8929963020',
      },
      'address': {
        'street': 'plot 39 sector 10',
        'street2': 'pacific apartment',
        'city': 'New Delhi',
        'state': 'DL',
        'postalCode': '110075',
        'country': 'IN',
      },
      'dateOfBirth': '1992-06-06',
      'passport': 'U1477306',
      'nationality': 'IN',
      'relationships': {
        // 'documents': {
        //   'data': [
        //     {
        //       'type': 'org',
        //       'id': '4219',
        //     },
        //   ],
        // },
      },
    };

    try {
      var customer = await UnitApiService().createCustomer(customerData);
      print('Customer created: $customer');
    } catch (e) {
      print('Error: $e');
    }
  }*/

  /*Future<void> getOrganizations() async {
    final response = await http.get(
      Uri.parse('https://api.s.unit.sh/organizations'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load organizations');
    }
  }

  Future<void> getApplications() async {
    final response = await http.get(
      Uri.parse('https://api.s.unit.sh/applications'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load applications');
    }
  }*/
}
