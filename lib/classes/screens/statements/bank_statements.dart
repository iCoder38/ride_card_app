import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/service/UNIT/bank_statement/bank_statement.dart';

class BankStatementsScreen extends StatefulWidget {
  const BankStatementsScreen({super.key, required this.bankId});

  final String bankId;

  @override
  State<BankStatementsScreen> createState() => _BankStatementsScreenState();
}

class _BankStatementsScreenState extends State<BankStatementsScreen> {
  bool screenLoader = true;
  var statementList = [];
  @override
  void initState() {
    Timer(const Duration(seconds: 1), getAllBankId);
    super.initState();
  }

  getAllBankId() async {
    var bankTransactionResponse = await getAllTransactions(
      TESTING_TOKEN,
      widget.bankId,
    );
    logger.d(bankTransactionResponse.last);
    statementList = bankTransactionResponse;
    setState(() {
      screenLoader = false;
    });
  }

  String extractTransactionType(String summary) {
    // Split the summary string using the separator ' | '
    List<String> parts = summary.split(' | ');

    // Return the second part of the summary, if it exists
    if (parts.length > 1) {
      return parts[1].trim(); // Trim to remove any extra spaces
    } else {
      return ''; // Return an empty string if the format is not as expected
    }
  }

  String formatCreatedAt(String createdAt) {
    // Parse the createdAt string to a DateTime object
    DateTime dateTime = DateTime.parse(createdAt);

    // Format the DateTime object to the desired format: dd-MM-yyyy
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: screenLoader == true
            ? Center(
                child: textFontPOOPINS(
                  'please wait...',
                  Colors.white,
                  16.0,
                ),
              )
            : _UIKitRequestMoneyAfterBG(context),
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
                Navigator.pop(context);
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
                  Icons.arrow_back,
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
                'Statement',
                Colors.white,
                18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      for (int i = statementList.length - 1; i >= 0; i--) ...[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // height: 70,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: statementList[i]['type'].toString() ==
                          'purchaseTransaction'
                      ? textFontPOOPINS(
                          'From card **** ${statementList[i]['attributes']['cardLast4Digits']}',
                          Colors.black,
                          16.0,
                          fontWeight: FontWeight.bold,
                        )
                      : textFontPOOPINS(
                          extractTransactionType(
                              statementList[i]['attributes']['summary']),
                          Colors.black,
                          16.0,
                        ),
                  subtitle: textFontPOOPINS(
                    formatCreatedAt(
                        statementList[i]['attributes']['createdAt']),
                    Colors.grey,
                    12.0,
                  ),
                  trailing:
                      statementList[i]['attributes']['direction'] == 'Credit'
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textFontPOOPINS(
                                  convertCentsToDollarsAsString(statementList[i]
                                          ['attributes']['amount']
                                      .toString()),
                                  Colors.green,
                                  16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textFontPOOPINS(
                                  convertCentsToDollarsAsString(statementList[i]
                                          ['attributes']['balance']
                                      .toString()),
                                  Colors.grey,
                                  10.0,
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textFontPOOPINS(
                                  convertCentsToDollarsAsString(statementList[i]
                                          ['attributes']['amount']
                                      .toString()),
                                  Colors.red,
                                  16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textFontPOOPINS(
                                  convertCentsToDollarsAsString(statementList[i]
                                          ['attributes']['balance']
                                      .toString()),
                                  Colors.grey,
                                  12.0,
                                ),
                              ],
                            ),
                  onTap: () async {
                    showLoadingUI(context, 'please wait...');
                    Map<String, dynamic>? transactionDetails =
                        await getTransactionDetails(
                      TESTING_TOKEN,
                      widget.bankId,
                      statementList[i]['id'].toString(),
                    );

                    if (transactionDetails != null) {
                      logger.d(transactionDetails['data']['type']);
                      Navigator.pop(context);
                      _openBottomSheet(
                        context,
                        statementList[i],
                        transactionDetails,
                      );
                    } else {
                      if (kDebugMode) {
                        print('Failed to fetch transaction details');
                      }
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        )
      ],
    ]);
  }

  void _openBottomSheet(BuildContext context, data, transactionData) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: transactionData['data']['type'].toString() ==
                  'purchaseTransaction'
              ? 280
              : 180,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              transactionData['data']['type'].toString() ==
                      'purchaseTransaction'
                  ? _UIPurchaseTransactions(transactionData)
                  : _UIBookTransactions(data, transactionData),
            ],
          ),
        );
      },
    );
  }

  Column _UIPurchaseTransactions(data) {
    return Column(
      children: [
        textFontPOOPINS(
          'Transaction information:',
          Colors.black,
          16.0,
          fontWeight: FontWeight.bold,
        ),
        ListTile(
          title: data['data']['attributes']['direction'] == 'Debit'
              ? ListTile(
                  title: textFontPOOPINS(
                    'Card payment **** ${data['data']['attributes']['cardLast4Digits']}',
                    Colors.black,
                    16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: textFontPOOPINS(
                    data['data']['attributes']['summary'].toString(),
                    Colors.grey,
                    12.0,
                  ),
                  trailing: textFontPOOPINS(
                    convertCentsToDollarsAsString(
                        data['data']['attributes']['balance'].toString()),
                    Colors.red,
                    16.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : textFontPOOPINS(
                  convertCentsToDollarsAsString(
                      data['data']['attributes']['balance'].toString()),
                  Colors.black,
                  16.0,
                  fontWeight: FontWeight.bold,
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 34.0, right: 34.0),
          child: Row(
            children: [
              textFontPOOPINS(
                'Service fee:',
                Colors.black,
                14.0,
              ),
              const Spacer(),
              data['data']['attributes']['internationalServiceFee'] == null
                  ? textFontPOOPINS(
                      '\$${"0"}',
                      Colors.black,
                      14.0,
                    )
                  : textFontPOOPINS(
                      data['data']['attributes']['internationalServiceFee']
                          .toString(),
                      Colors.black,
                      14.0,
                    ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 34.0, right: 34.0),
          child: Row(
            children: [
              textFontPOOPINS(
                'Payment method:',
                Colors.black,
                14.0,
              ),
              const Spacer(),
              textFontPOOPINS(
                data['data']['attributes']['paymentMethod'].toString(),
                Colors.black,
                14.0,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 34.0, right: 34.0),
          child: Row(
            children: [
              textFontPOOPINS(
                'Card network:',
                Colors.black,
                14.0,
              ),
              const Spacer(),
              textFontPOOPINS(
                data['data']['attributes']['cardNetwork'].toString(),
                Colors.black,
                14.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _UIBookTransactions(data, transactionData) {
    return Column(
      children: [
        ListTile(
          title: Column(
            children: [
              if (extractTransactionType(data['attributes']['summary']) ==
                  'BankToBank - Other') ...[
                textFontPOOPINS(
                  'Bank to bank transfer',
                  Colors.black,
                  16.0,
                  fontWeight: FontWeight.bold,
                ),
              ] else if (extractTransactionType(
                      data['attributes']['summary']) ==
                  'BankToBank - Self') ...[
                textFontPOOPINS(
                  'Self bank transfer',
                  Colors.black,
                  16.0,
                  fontWeight: FontWeight.bold,
                ),
              ] else if (extractTransactionType(
                      data['attributes']['summary']) ==
                  'Withdraw ( wallet )') ...[
                textFontPOOPINS(
                  'Withdraw from wallet',
                  Colors.black,
                  16.0,
                  fontWeight: FontWeight.bold,
                ),
              ] else if (extractTransactionType(
                      data['attributes']['summary']) ==
                  'Withdraw ( wallet )') ...[
                textFontPOOPINS(
                  'Withdraw from wallet',
                  Colors.black,
                  16.0,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ],
          ),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ListTile(
          title: textFontPOOPINS(
            transactionData['data']['attributes']['counterparty']['name']
                .toString(),
            Colors.black,
            16.0,
          ),
          subtitle: textFontPOOPINS(
            'AN: ${transactionData['data']['attributes']['counterparty']['accountNumber']}',
            Colors.grey,
            12.0,
          ),
          trailing: data['attributes']['direction'] == 'Credit'
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textFontPOOPINS(
                      convertCentsToDollarsAsString(
                          data['attributes']['amount'].toString()),
                      Colors.green,
                      14.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textFontPOOPINS(
                      formatCreatedAt(data['attributes']['createdAt']),
                      Colors.grey,
                      12.0,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textFontPOOPINS(
                      convertCentsToDollarsAsString(
                          data['attributes']['amount'].toString()),
                      Colors.red,
                      14.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textFontPOOPINS(
                      formatCreatedAt(data['attributes']['createdAt']),
                      Colors.grey,
                      12.0,
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
