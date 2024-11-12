import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/StripeAPIs/create_bank_account.dart';
import 'package:ride_card_app/classes/StripeAPIs/create_customer.dart';
import 'package:ride_card_app/classes/StripeAPIs/link_bank_account.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AddBankScreen extends StatefulWidget {
  const AddBankScreen({super.key});

  @override
  State<AddBankScreen> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  var screenLoader = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  // final TextEditingController _contFirstName = TextEditingController();
  var storeStripeCustomerId = '';
  final TextEditingController _contAccountNumber = TextEditingController();
  final TextEditingController _contRoutingNumber = TextEditingController();
  final TextEditingController _contSSN = TextEditingController();
  // final TextEditingController _contAccountType = TextEditingController();
  //
  @override
  void initState() {
    super.initState();
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            //
            const SizedBox(height: 80.0),
            customNavigationBar(context, 'Add bank'),
            const SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 219, 218, 218),
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    readOnly: false,
                    controller: _contAccountNumber,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Account number',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10.0,
                      ),
                      /*suffixIcon: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: svgImage('email', 14.0, 14.0),
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
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 219, 218, 218),
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    readOnly: false,
                    controller: _contRoutingNumber,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Rounting number',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10.0,
                      ),
                      /*suffixIcon: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: svgImage('email', 14.0, 14.0),
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
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 219, 218, 218),
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    readOnly: false,
                    controller: _contSSN,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'SSN',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10.0,
                      ),
                      /*suffixIcon: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: svgImage('email', 14.0, 14.0),
                      ),*/
                    ),
                    maxLength: 9,
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

            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    dismissKeyboard(context);
                    showLoadingUI(context, PLEASE_WAIT);
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
      ),
    );
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
          /*createCustomerInStripe(
            '${v["data"]["fullName"]} ${v["data"]["lastName"]}',
            v["data"]["email"].toString(),
          );*/
        }
      } else {
        logger.d('Mode: Live');
        if (v["data"]["stripe_customer_id_Live"].toString() == '') {
          /*createCustomerInStripe(
            '${v["data"]["fullName"]} ${v["data"]["lastName"]}',
            v["data"]["email"].toString(),
          );*/
        } else {
          storeStripeCustomerId =
              v["data"]["stripe_customer_id_Live"].toString();
          addBankAccount();
        }
      }
    });
  }

  // create customer in stripe
  /*void createCustomerInStripe(
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
  }*/

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
          addBankAccount();
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }*/

  //
  String getLast4Digits(String fullString) {
    // Ensure the string is at least 4 characters long
    if (fullString.length >= 4) {
      return fullString.substring(fullString.length - 4);
    } else {
      // Handle case where string is too short
      return fullString;
    }
  }

  Future<void> addBankAccount() async {
    var id = const Uuid().v4().toString();
    String last4Digits = getLast4Digits(_contSSN.text.toString());

    String userEmail = loginUserEmail();
    String accountNumber = _contAccountNumber.text.toString();
    String country = "US";
    String currency = "usd";
    String accountHolderName = loginUserName();
    String accountHolderType = "individual";
    String routingNumber = _contRoutingNumber.text.toString();

    Map<String, String> result = await connectBankAccount(
        userEmail: userEmail,
        accountNumber: accountNumber,
        country: country,
        currency: currency,
        accountHolderName: accountHolderName,
        accountHolderType: accountHolderType,
        routingNumber: routingNumber,
        ssnNumber: _contSSN.text.toString(),
        ssnNumber4: last4Digits.toString());

    if (result['status'] == 'success') {
      if (kDebugMode) {
        print(
            "Bank account connected successfully. Bank Account ID: ${result['message']}");
      }

      FirebaseFirestore.instance
          .collection(
            'RIDE_WALLET/STRIPE_CONNECT_ACCOUNTS/BANK_ACCOUNTS',
          )
          .doc(id)
          .set(
        {
          'id': id,
          'accountId': result['message'].toString(),
          'bankAccountNumber': _contAccountNumber.text.toString(),
          'bankRoutingNumber': _contRoutingNumber.text.toString(),
          'userId': loginUserId(),
          'active': false,
        },
      ).then((v) {
        _contAccountNumber.text = "";
        _contRoutingNumber.text = "";
        dismissKeyboard(context);
        Navigator.pop(context);
        customToast(
          'Successfully created.',
          Colors.red,
          ToastGravity.BOTTOM,
        );
        // Navigator.pop(context, 'refresh');
      });
    } else {
      if (result['message'] ==
          'Exception: Failed to create bank account token: Routing number must have 9 digits') {
        dismissKeyboard(context);
        Navigator.pop(context);
        customToast(
          result['message'].toString(),
          Colors.red,
          ToastGravity.BOTTOM,
        );
      } else if (result['message'] ==
          'Exception: Failed to create bank account token: You must use a test bank account number in test mode. Try 000123456789 or see more options at https://stripe.com/docs/connect/testing#account-numbers.') {
        dismissKeyboard(context);
        Navigator.pop(context);
        customToast(
          'Bank account number is invalid. Please check and enter valid bank account number.',
          Colors.red,
          ToastGravity.BOTTOM,
        );
      } else {
        dismissKeyboard(context);
        Navigator.pop(context);
        customToast(
          'Something went wrong. Please try again after sometime.',
          Colors.red,
          ToastGravity.BOTTOM,
        );
      }
      if (kDebugMode) {
        print("Failed to connect bank account: ${result['message']}");
      }
    }

    /* try {
      final bankAccountToken = await createBankAccountTokenAPI(
        accountNumber: _contAccountNumber.text.toString(),
        country: 'US',
        currency: 'usd',
        accountHolderName: loginUserName(),
        accountHolderType: 'individual',
        routingNumber: _contRoutingNumber.text.toString(),
      );

      if (bankAccountToken != null && storeStripeCustomerId.isNotEmpty) {
        final response = await attachBankAccountToCustomerAPI(
          customerId: storeStripeCustomerId,
          bankAccountToken: bankAccountToken,
        );

        if (response.statusCode == 200) {
          Navigator.pop(context);
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Bank account added successfully!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          _contAccountNumber.text = "";
          _contRoutingNumber.text = "";
          FirebaseFirestore.instance
              .collection(
                'RIDE_WALLET/STRIPE_CONNECT_ACCOUNTS/BANK_ACCOUNTS',
              )
              .doc(id)
              .set(
            {
              'id': id,
              'bankAccountNumber': _contAccountNumber.text.toString(),
              'bankRoutingNumber': _contRoutingNumber.text.toString(),
              'userId': loginUserId(),
            },
          );
          Navigator.pop(context, 'refresh');
        } else {
          // Parse the error message
          final responseData = json.decode(response.body);
          final errorMessage = responseData['error']?['message'] ??
              'Failed to add bank account. Please try again.';

          Navigator.pop(context);
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        Navigator.pop(context);
        // Handle case where token creation fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create bank account token.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      // Show error if an exception occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }*/
  }
}
