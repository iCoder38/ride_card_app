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
import 'package:ride_card_app/classes/service/UNIT/CUSTOMER/get_customer_accounts_list/get_customer_account_list.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';

class SelfTransferScreen extends StatefulWidget {
  const SelfTransferScreen({super.key});

  @override
  State<SelfTransferScreen> createState() => _SelfTransferScreenState();
}

class _SelfTransferScreenState extends State<SelfTransferScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  final TextEditingController contFrom = TextEditingController();
  final TextEditingController contTo = TextEditingController();
  final TextEditingController contAmount = TextEditingController();
  var storeUnitBankId = '0';
  var customerID = '';
  var selectedFromAccountId = '';
  var selectedToAccountId = '';
  var userSelect = '';
  List<dynamic>? accountDetails;
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
                'Self transfer',
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
              readOnly: true,
              controller: contFrom,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'From account',
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
              onTap: () {
                userSelect = '1';
                showLoadingUI(context, 'please wait...');
                fetchProfileData();
              },
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 20.0,
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
              controller: contTo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'To Account',
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
              onTap: () {
                userSelect = '2';
                showLoadingUI(context, 'please wait...');
                fetchProfileData();
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
        height: 20.0,
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
      Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        child: GestureDetector(
          onTap: () async {
            // if (_formKey.currentState!.validate()) {
            if (contFrom.text == '') {
              return;
            }
            if (contTo.text == '') {
              return;
            }
            if (contAmount.text == '') {
              return;
            }
            showLoadingUI(context, PLEASE_WAIT);
            sendPayment();
            //
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
    if (userSelect == '1') {
      _showAccountSelectionSheetFrom(context);
    } else {
      _showAccountSelectionSheetTo(context);
    }
  }

  void _showAccountSelectionSheetFrom(BuildContext context) {
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
                          contFrom.text = accountNumber.toString();
                          selectedFromAccountId = accountId;
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

  void _showAccountSelectionSheetTo(BuildContext context) {
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
                          contTo.text = accountNumber.toString();
                          selectedToAccountId = accountId;
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
          "description": "BankToBank - Self",
        },
        "relationships": {
          "account": {
            "data": {
              "type": "depositAccount",
              "id": selectedFromAccountId.toString()
            }
          },
          "counterpartyAccount": {
            "data": {
              "type": "depositAccount",
              "id": selectedToAccountId.toString(),
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
        contFrom.text = "";
        contTo.text = "";
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
