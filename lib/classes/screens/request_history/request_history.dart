import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/service/service.dart';

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

  //
  @override
  void initState() {
    //
    _allRecentTransaction(context);
    super.initState();
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
          TEXT_NAVIGATION_TITLE_REQUEST_HISTORY,
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
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: textFontPOOPINS(
                          //
                          'Money added',
                          Colors.black,
                          18.0,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: arrAllUser[i]['trn_date'].toString() == ''
                            ? textFontPOOPINS(
                                // sv
                                '',
                                Colors.grey,
                                12.0,
                                fontWeight: FontWeight.w500,
                              )
                            : textFontPOOPINS(
                                // sv
                                formatDate(
                                    arrAllUser[i]['trn_date'].toString()),
                                Colors.grey,
                                12.0,
                                fontWeight: FontWeight.w500,
                              ),
                        trailing: Container(
                          width: 120,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.add,
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
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ] else if (arrAllUser[i]['type'] == 'Sent') ...[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: textFontPOOPINS(
                          //
                          'Money sent',
                          Colors.black,
                          18.0,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: arrAllUser[i]['trn_date'].toString() == ''
                            ? textFontPOOPINS(
                                // sv
                                '',
                                Colors.grey,
                                12.0,
                                fontWeight: FontWeight.w500,
                              )
                            : textFontPOOPINS(
                                // sv
                                formatDate(
                                    arrAllUser[i]['trn_date'].toString()),
                                Colors.grey,
                                12.0,
                                fontWeight: FontWeight.w500,
                              ),
                        trailing: Container(
                          width: 120,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.arrow_outward,
                                size: 16.0,
                                color: Colors.orangeAccent,
                              ),
                              const SizedBox(width: 4.0),
                              textFontORBITRON(
                                //
                                arrAllUser[i]['amount'].toString(),
                                Colors.orangeAccent,
                                18.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ] else ...[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: textFontPOOPINS(
                          //
                          'Money sent',
                          Colors.black,
                          18.0,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: arrAllUser[i]['trn_date'].toString() == ''
                            ? textFontPOOPINS(
                                // sv
                                '',
                                Colors.grey,
                                12.0,
                                fontWeight: FontWeight.w500,
                              )
                            : textFontPOOPINS(
                                // sv
                                formatDate(
                                    arrAllUser[i]['trn_date'].toString()),
                                Colors.grey,
                                12.0,
                                fontWeight: FontWeight.w500,
                              ),
                        trailing: Container(
                          width: 120,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.remove,
                                size: 16.0,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4.0),
                              textFontORBITRON(
                                //
                                arrAllUser[i]['amount'].toString(),
                                Colors.red,
                                18.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
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
}
