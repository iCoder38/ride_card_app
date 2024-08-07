import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/screens/all_accounts/account_details/account_details.dart';
import 'package:ride_card_app/classes/service/UNIT/ACCOUNT/create_account/create_account.dart';
import 'package:ride_card_app/classes/service/UNIT/CUSTOMER/get_customer_accounts_list/get_customer_account_list.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:uuid/uuid.dart';

class AllAccountsScreen extends StatefulWidget {
  const AllAccountsScreen({super.key});

  @override
  State<AllAccountsScreen> createState() => _AllAccountsScreenState();
}

class _AllAccountsScreenState extends State<AllAccountsScreen> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var customerID = '0';
  List<dynamic>? accountDetails;
  var screenLoader = true;
  bool floatingVisibility = false;
  bool? accountCreated;
  var myFullData;
  var accountStatusMessage = 'No account added yet. Click plus to add.';
  var customerType = '';
  //
  @override
  void initState() {
    fetchProfileData();

    super.initState();
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
                    child: textFontPOOPINS(
                      //
                      'Are you sure you want to create an account ?',
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
                        _createAccount(context);
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: Center(
                          child: textFontPOOPINS(
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

  void _createAccount(context) async {
    showLoadingUI(context, 'please wait...');
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
    Navigator.pop(context);
    customToast('created', Colors.green, ToastGravity.BOTTOM);
    fetchAccountDetails();
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

    //
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
}
