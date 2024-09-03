import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestHistoryScreen extends StatefulWidget {
  const RequestHistoryScreen({super.key, required this.menuBar});

  final String menuBar;

  @override
  State<RequestHistoryScreen> createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var arrAllUser = [];
  bool screenLoader = true;
  bool resultLoader = true;
  var strLoginUserId = '0';
  //
  @override
  void initState() {
    //
    getLoginUserId(context);
    super.initState();
  }

  getLoginUserId(context) async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    var userID = prefs2.getString('Key_save_login_user_id').toString();
    strLoginUserId = userID.toString();
    //
    _allRecentTransaction(context);
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
        color: Colors.amber,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: screenLoader == true
          ? customCircularProgressIndicator()
          : arrAllUser.isEmpty
              ? Center(
                  child: textFontPOOPINS(
                      'No transaction found', Colors.white, 12.0))
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _UIKitRequestHistoryAfterBG(context),
                ),
    );
  }

  Widget _UIKitRequestHistoryAfterBG(context) {
    return Column(
      children: [
        const SizedBox(
          height: 80.0,
        ),
        customNavigationBarForMenu(
          'History',
          _scaffoldKey,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 20.0,
          ),
          child: Container(
            // height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(
                16.0,
              ),
            ),
            child: Column(
              children: [
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
                                  fontWeight: FontWeight.w600,
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
                                        fontWeight: FontWeight.w200,
                                      )
                                    : textFontPOOPINS(
                                        // sv
                                        formatDate(arrAllUser[i]['trn_date']
                                            .toString()),
                                        Colors.grey,
                                        10.0,
                                        fontWeight: FontWeight.w200,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        showTransactionDetails(context, arrAllUser[i]);
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
                        width: 130,
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
                                // const SizedBox(width: 4.0),
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
                                        fontWeight: FontWeight.w200,
                                      )
                                    : textFontPOOPINS(
                                        // sv
                                        formatDate(arrAllUser[i]['trn_date']
                                            .toString()),
                                        Colors.grey,
                                        10.0,
                                        fontWeight: FontWeight.w200,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        showTransactionDetails(context, arrAllUser[i]);
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
                                        fontWeight: FontWeight.w200,
                                      )
                                    : textFontPOOPINS(
                                        // sv
                                        formatDate(arrAllUser[i]['trn_date']
                                            .toString()),
                                        Colors.grey,
                                        10.0,
                                        fontWeight: FontWeight.w200,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        showTransactionDetails(context, arrAllUser[i]);
                      },
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
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
              child: textFontPOOPINS(
                'Close',
                Colors.black,
                14.0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
