import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/success/success.dart';
import 'package:ride_card_app/classes/screens/wallet/add_money/add_money.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/send_money.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/service/service.dart';
import 'package:ride_card_app/classes/screens/wallet/widgets/widgets.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  //

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  var myFullData;
  var arrAllUser = [];
  bool screenLoader = true;
  bool resultLoader = true;
  var strLoginUserId = '0';
  //
  @override
  void initState() {
    //

    getLoginUserId();
    super.initState();
  }

  getLoginUserId() async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    var userID = prefs2.getString('Key_save_login_user_id').toString();
    strLoginUserId = userID.toString();
    //
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) {
      myFullData = v;
      if (kDebugMode) {
        print(myFullData);
      }
      //
      _allRecentTransaction(context);

      // parseValue();
    });
    // print(responseBody);
  }

  void _allRecentTransaction(BuildContext context) async {
    List<dynamic> transactions =
        await TransactionService.transacctionHistory(context);
    if (transactions.isNotEmpty) {
      // Success: Handle the transactions list as needed
      if (kDebugMode) {
        print('Success: Transactions fetched successfully');
      }
      arrAllUser = transactions;
      setState(() {
        resultLoader = false;
        screenLoader = false;
      });
    } else {
      // Failure: Handle the empty list or error case
      if (kDebugMode) {
        print('Failure: No transactions found or an error occurred');
      }
      setState(() {
        resultLoader = false;
        screenLoader = false;
      });
    }
    // Handle the transactions list as needed
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
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: screenLoader == true
          ? customCircularProgressIndicator()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: _UIKitWalletAfterBG(context),
            ),
    );
  }

  Widget _UIKitWalletAfterBG(context) {
    return Column(
      children: [
        const SizedBox(
          height: 80.0,
        ),
        Row(
          children: [
            customNavigationBarForMenu(
              TEXT_NAVIGATION_TITLE_WALLET,
              _scaffoldKey,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                //
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return BottomSheetContent();
                  },
                );
              },
              child: Container(
                height: 40,
                width: 130,
                decoration: BoxDecoration(
                  color: hexToColor(appREDcolorHexCode),
                  borderRadius: BorderRadius.circular(
                    14.0,
                  ),
                ),
                child: Center(
                  child: textFontPOOPINS(
                    'Withdraw',
                    Colors.white,
                    16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Row(
              children: [
                widgetWalletUpperDeckContainerLeft(
                  context,
                  myFullData['data']['wallet'].toString(),
                ),
                Expanded(
                  child: Container(
                    height: 120,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            //
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SendMoneyScreen(
                                  menuBar: 'no',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 130,
                            decoration: BoxDecoration(
                              color: hexToColor(appORANGEcolorHexCode),
                              borderRadius: BorderRadius.circular(
                                14.0,
                              ),
                            ),
                            child: Center(
                              child: textFontPOOPINS(
                                'Send',
                                Colors.white,
                                16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        GestureDetector(
                          onTap: () {
                            //
                            pushToAddMoney(context);
                          },
                          child: Container(
                            height: 40,
                            width: 130,
                            decoration: BoxDecoration(
                              color: hexToColor(appREDcolorHexCode),
                              borderRadius: BorderRadius.circular(
                                14.0,
                              ),
                            ),
                            child: Center(
                              child: textFontPOOPINS(
                                'Add money',
                                Colors.white,
                                16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: textFontPOOPINS(
              'Transactions',
              Colors.orangeAccent,
              16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        for (int i = 0; i < arrAllUser.length; i++) ...[
          if (arrAllUser[i]['type'] == 'Add') ...[
            ListTile(
              title: textFontPOOPINS(
                //
                'Money added',
                Colors.white,
                18.0,
                fontWeight: FontWeight.w600,
              ),
              subtitle: textFontPOOPINS(
                //
                'Me',
                //FirebaseAuth.instance.currentUser!.displayName,
                Colors.grey,
                12.0,
                fontWeight: FontWeight.w500,
              ),
              trailing: Container(
                width: 120,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.add,
                          size: 24.0,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4.0),
                        textFontORBITRON(
                          //
                          arrAllUser[i]['amount'].toString(),
                          Colors.green,
                          18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        arrAllUser[i]['trn_date'].toString() == ''
                            ? textFontPOOPINS(
                                // sv
                                '',
                                Colors.grey,
                                10.0,
                                fontWeight: FontWeight.w500,
                              )
                            : textFontPOOPINS(
                                // sv
                                formatDate(
                                    arrAllUser[i]['trn_date'].toString()),
                                Colors.grey,
                                10.0,
                                fontWeight: FontWeight.w500,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                // showTransactionDetails(context, arrAllUser[i]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuccessScreen(
                      receiverData: arrAllUser[i],
                      responseData: arrAllUser[i],
                      amount: arrAllUser[i]['amount'].toString(),
                      showButton: false,
                      status: '2',
                    ),
                  ),
                );
              },
            ),
          ] else if (arrAllUser[i]['senderId'].toString() ==
              strLoginUserId) ...[
            // sent money
            ListTile(
              title: textFontPOOPINS(
                //
                'Money sent',
                Colors.white,
                18.0,
                fontWeight: FontWeight.w600,
              ),
              subtitle: textFontPOOPINS(
                //
                'To: ${arrAllUser[i]['userName']}',
                Colors.grey,
                12.0,
                fontWeight: FontWeight.w500,
              ),
              trailing: Container(
                width: 120,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.remove,
                          size: 16.0,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 4.0),
                        textFontORBITRON(
                          //
                          arrAllUser[i]['amount'].toString(),
                          Colors.redAccent,
                          18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        arrAllUser[i]['trn_date'].toString() == ''
                            ? textFontPOOPINS(
                                // sv
                                '',
                                Colors.grey,
                                10.0,
                                fontWeight: FontWeight.w500,
                              )
                            : textFontPOOPINS(
                                // sv
                                formatDate(
                                    arrAllUser[i]['trn_date'].toString()),
                                Colors.grey,
                                10.0,
                                fontWeight: FontWeight.w500,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                // showTransactionDetails(context, arrAllUser[i]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuccessScreen(
                      receiverData: arrAllUser[i],
                      responseData: arrAllUser[i],
                      amount: arrAllUser[i]['amount'].toString(),
                      showButton: false,
                      status: '1',
                    ),
                  ),
                );
              },
            ),
          ] else ...[
            ListTile(
              title: textFontPOOPINS(
                //
                'Money received',
                Colors.white,
                18.0,
                fontWeight: FontWeight.w600,
              ),
              subtitle: textFontPOOPINS(
                'From: ${arrAllUser[i]['sender_userName']}',
                Colors.grey,
                12.0,
                fontWeight: FontWeight.w500,
              ),
              trailing: Container(
                width: 120,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.arrow_outward,
                          size: 16.0,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4.0),
                        textFontORBITRON(
                          //
                          arrAllUser[i]['amount'].toString(),
                          Colors.green,
                          18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        arrAllUser[i]['trn_date'].toString() == ''
                            ? textFontPOOPINS(
                                // sv
                                '',
                                Colors.grey,
                                10.0,
                                fontWeight: FontWeight.w500,
                              )
                            : textFontPOOPINS(
                                // sv
                                formatDate(
                                    arrAllUser[i]['trn_date'].toString()),
                                Colors.grey,
                                10.0,
                                fontWeight: FontWeight.w500,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                // showTransactionDetails(context, arrAllUser[i]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuccessScreen(
                      receiverData: arrAllUser[i],
                      responseData: arrAllUser[i],
                      amount: arrAllUser[i]['amount'].toString(),
                      showButton: false,
                      status: '3',
                    ),
                  ),
                );
              },
            ),
          ],
        ],
        const Divider(
          thickness: 0.2,
        )
      ],
    );
  }

  void showTransactionDetails(
    BuildContext context,
    data,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textFontPOOPINS('Details', Colors.black, 16.0),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                textFontPOOPINS(
                    'Transaction id: 0000${data['transactionId'].toString()}',
                    Colors.black,
                    14.0),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //
  Future<void> pushToAddMoney(
    BuildContext context,
  ) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMoneyScreen(),
      ),
    );

    if (!mounted) return;
    //
    if (result == 'reload_screen') {
      if (kDebugMode) {
        print(result);
      }
      //
      fetchProfileData();
      //
    }
  }
}

class BottomSheetContent extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  BottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    // To detect keyboard size and apply padding
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: keyboardHeight, // Add padding equal to the keyboard height
        top: 16.0,
      ),
      child: SingleChildScrollView(
        // Allows scrolling when content overflows
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Amount',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle submission logic here
                  String amount = amountController.text;
                  String description = descriptionController.text;

                  // Example: Print the values or pass them somewhere
                  if (kDebugMode) {
                    print('Amount: $amount, Description: $description');
                  }
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
