import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/service/UNIT/CUSTOMER/get_customer_accounts_list/get_customer_account_list.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankToBankTransfterScreen extends StatefulWidget {
  const BankToBankTransfterScreen({super.key});

  @override
  State<BankToBankTransfterScreen> createState() =>
      _BankToBankTransfterScreenState();
}

class _BankToBankTransfterScreenState extends State<BankToBankTransfterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  final TextEditingController contName = TextEditingController();
  final TextEditingController contAccountNumber = TextEditingController();
  final TextEditingController contRoutingNumber = TextEditingController();
  final TextEditingController contAmount = TextEditingController();
  final TextEditingController contAccountType = TextEditingController();
  final TextEditingController contYourBankAccount = TextEditingController();

  final GenerateTokenService _apiServiceGT = GenerateTokenService();
  var storeUnitBankId = '0';
  var customerID = '';
  var selectedAccountId = '';
  List<dynamic>? accountDetails;
  //
  @override
  void initState() {
    // sendPayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: _UIKit(context),
      /*body: Column(
        children: [
          const SizedBox(
            height: 80.0,
          ),
          customNavigationBar(context, 'Bank transfer'),
        ],
      ),*/
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
        child: _UIKitRequestMoneyAfterBG(context),
      ),
    );
  }

  Widget _UIKitRequestMoneyAfterBG(context) {
    return Column(children: [
      const SizedBox(
        height: 80.0,
      ),

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
                'Bank to bank',
                Colors.white,
                18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 30.0,
      ),
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
              controller: contName,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Account holder name',
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
      const SizedBox(
        height: 30.0,
      ),
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
              controller: contAccountNumber,
              keyboardType: TextInputType.emailAddress,
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

      ///
      ///
      ///
      ///
      const SizedBox(
        height: 30.0,
      ),
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
              controller: contRoutingNumber,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Routing number',
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
      //
      const SizedBox(
        height: 30.0,
      ),
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
              controller: contAmount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Amount',
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

      ///
      ///
      ///
      ///
      const SizedBox(
        height: 30.0,
      ),
      Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          child: Center(
            child: TextFormField(
              readOnly: true,
              controller: contAccountType,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Deposit account',
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

      ///
      ///
      ///
      ///
      const SizedBox(
        height: 30.0,
      ),
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
              onTap: () {
                showLoadingUI(context, 'please wait...');
                fetchProfileData();
                // Open the bottom sheet when tapped
              },
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
            // if (_formKey.currentState!.validate()) {
            showLoadingUI(context, PLEASE_WAIT);
            //
            checkAndGetBankAccount(contAccountNumber.text.toString());
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
                'Transfer',
                Colors.white,
                18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
  // transfer

  checkAndGetBankAccount(accountNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();

    final parameters = {
      'action': 'accountlist',
      'keyword': accountNumber.toString(),
    };
    if (kDebugMode) {
      logger.d(parameters);
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
            checkAndGetBankAccount(accountNumber);
          });
        } else {
          if (successStatus.toLowerCase() == 'success') {
            //
            var allAccountsInArray = [];
            Map<String, dynamic> jsonResponse = jsonDecode(response.body);
            var responseData = jsonResponse['data'];
            allAccountsInArray = responseData;
            // print(allAccountsInArray);
            for (int i = 0; i < allAccountsInArray.length; i++) {
              if (kDebugMode) {
                print(i);
              }
              // print(allAccountsInArray[i])
              if (contAccountNumber.text.toString() ==
                  allAccountsInArray[i]['account_number'].toString()) {
                debugPrint('This is an UNIT bank account.');
                storeUnitBankId =
                    allAccountsInArray[i]['unitBankId'].toString();
              }
            }
            logger.d('BankId:==> $storeUnitBankId');
            sendPayment();
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

  // EVS: API => GET USER PROFILE DATA
  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) {
      customerID = v['data']['customerId'].toString();
      debugPrint('CUSTOM ID ==> $customerID');
      fetchAccountDetails();
    });
  }

  Future<void> fetchAccountDetails() async {
    accountDetails = await GetAllUnitAccountsService
        .getParticularAccountDetailsViaCustomerId(customerID);
    logger.d(accountDetails?[0]);
    Navigator.pop(context);
    _showAccountSelectionSheet(context);
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
    var convertAmount = convertDollarsToCentsAsString(
      contAmount.text.toString(),
    );
    final url = Uri.parse('https://api.s.unit.sh/payments');
    final headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    final body = jsonEncode({
      "data": {
        "type": "bookPayment",
        "attributes": {
          "amount": convertAmount.toString(),
          "description": "BankToBank - Other",
        },
        "relationships": {
          "account": {
            "data": {
              "type": "depositAccount",
              "id": selectedAccountId.toString()
            }
          },
          "counterpartyAccount": {
            "data": {
              "type": "depositAccount",
              "id": storeUnitBankId.toString(),
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
        contAccountNumber.text = "";
        contName.text = "";
        contRoutingNumber.text = "";
        contYourBankAccount.text = "";
        contAmount.text = "";
        Navigator.pop(context);
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
}
