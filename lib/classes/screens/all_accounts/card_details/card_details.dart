import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/neopop.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
// import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/all_accounts/card_details/alert/alert.dart';
import 'package:ride_card_app/classes/service/UNIT/CARD/check_limit/check_limit.dart';
import 'package:ride_card_app/classes/service/UNIT/CARD/close_card/close_card.dart';

import 'package:ride_card_app/classes/service/UNIT/CARD/freeze_unfreeze_card/freeze_unfreeze_card.dart';

// import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/service/UNIT/CARD/pin_status/pin_status.dart';
import 'package:ride_card_app/classes/service/UNIT/CUSTOMER/customer_token/customer_token.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key, this.cardData});

  final cardData;

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  //
  var storeCardId = '';
  var strPinStatus = '';
  bool pinStatusLoader = true;
  var storeCustomerFullData;
  var storeCustomerToken = '';
  var storeCustomerId = '';
  var strSelectType = '0';
  //
  var strCardStatus = '';
  //
  late final WebViewController webViewController;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();
  late WebViewController _controller;
  //
  @override
  void initState() {
    if (kDebugMode) {
      print('======== CARD DATA ==============');
      print(widget.cardData);
      print(widget.cardData['id']);
      print('=================================');
    }
    // _controller = WebViewController();
    // _controller.loadFlutterAsset('assets/images/display_card_details.html');
    //
    /*_controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('assets/images/display_card_details.html');*/
    // ..loadRequest(
    //   Uri.parse('https://www.instagram.com'),
    // );
    storeCardId = widget.cardData['id'].toString();
    strCardStatus = widget.cardData['attributes']['status'].toString();
    if (kDebugMode) {
      print(strCardStatus);
    }
    //  _passValuesToWebView();
    if (strCardStatus != 'ClosedByCustomer') {
      fetchProfileData();
    }

    //
    super.initState();
  }

  /*void _passValuesToWebView() {
    String customerToken = '';
    String cardId = '2067451';
    _injectJavaScript(customerToken, cardId);
  }

  void _injectJavaScript(String customerToken, String cardId) {
    String script = """
      const show = VGSShow.create('tntazhyknp1');
      const customerToken = "$customerToken";
      const cardId = "$cardId";

      const cvv2iframe = show.request({
        name: 'data-text',
        method: 'GET',
        path: '/cards/' + cardId + '/secure-data/cvv2',
        headers: {
          "Authorization": "Bearer " + customerToken
        },
        htmlWrapper: 'text',
        jsonPathSelector: 'data.attributes.cvv2'
      });
      cvv2iframe.render('#cvv2');

      const cardNumberIframe = show.request({
        name: 'data-text',
        method: 'GET',
        path: '/cards/' + cardId + '/secure-data/pan',
        headers: {
          "Authorization": "Bearer " + customerToken
        },
        htmlWrapper: 'text',
        jsonPathSelector: 'data.attributes.pan'
      });
      cardNumberIframe.render('#cardNumber');
    """;
    _controller.runJavaScript(script);
  }*/

  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) async {
      if (kDebugMode) {
        print(v['data']['customerId']);
      }
      storeCustomerFullData = v;
      storeCustomerId = v['data']['customerId'].toString();
      // check pin status
      fetchCardPinStatus(widget.cardData['id']);
      //
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      child: _UIKitCardDetailsAfterBG(context),
    );
  }

  Widget _UIKitCardDetailsAfterBG(context) {
    return Column(
      children: [
        const SizedBox(
          height: 80,
        ),
        //
        customNavigationBar(context, TEXT_NAVIGATION_TITLE_CARDS_DETAILS),
        //
        const SizedBox(
          height: 40.0,
        ),

        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 10.0,
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
                  'card',
                  14.0,
                  14.0,
                ),
              ),
              title: textFontPOOPINS(
                //
                '**** **** **** ${widget.cardData['attributes']['last4Digits'].toString()}',
                Colors.black,
                16.0,
                fontWeight: FontWeight.w600,
              ),
              subtitle: textFontPOOPINS(
                //
                'Exp. date: ${widget.cardData['attributes']['expirationDate']}',
                Colors.grey,
                10.0,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.cardData['attributes']['status'].toString() ==
                      'Active') ...[
                    textFontPOOPINS(
                      //
                      widget.cardData['attributes']['status'].toString(),
                      Colors.green,
                      10.0,
                      fontWeight: FontWeight.w700,
                    )
                  ] else if (widget.cardData['attributes']['status']
                          .toString() ==
                      'Frozen') ...[
                    textFontPOOPINS(
                      //
                      widget.cardData['attributes']['status'].toString(),
                      Colors.green,
                      10.0,
                      fontWeight: FontWeight.w700,
                    )
                  ] else ...[
                    textFontPOOPINS(
                      //
                      'Closed',
                      Colors.redAccent,
                      10.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ]
                ],
              ),
              onTap: () {
                //
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardDetailsScreen(
                      cardData: widget.cardData,
                    ),
                  ),
                );*/
              },
            ),
          ),
        ),
        strCardStatus == 'ClosedByCustomer'
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    if (pinStatusLoader == true) ...[
                      textFontPOOPINS(
                        'Pin: ...',
                        Colors.white,
                        14.0,
                      ),
                      IconButton(
                        onPressed: () {
                          //
                          setState(() {
                            pinStatusLoader = true;
                          });
                          fetchCardPinStatus(storeCardId);
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 18.0,
                        ),
                      )
                    ] else ...[
                      if (strPinStatus == 'NotSet') ...[
                        Row(
                          children: [
                            textFontPOOPINS(
                              'Pin: ',
                              Colors.white,
                              14.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                //
                                strSelectType = '1';
                                if (kDebugMode) {
                                  print('CLICKED ==> NOT SET');
                                }
                                /*if (kDebugMode) {
                            print(widget.cardData['id']);
                            print(storeCustomerToken);
                          }*/
                                showLoadingUI(context, 'please wait...');
                                fetchCustomerToken(
                                  storeCustomerFullData['data']['customerId']
                                      .toString(),
                                );
                              },
                              child: Text(
                                'Not Set',
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                    decorationThickness: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                //
                                setState(() {
                                  pinStatusLoader = true;
                                });
                                fetchCardPinStatus(storeCardId);
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 18.0,
                              ),
                            )
                          ],
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 14.0,
                              ),
                              const SizedBox(width: 10.0),
                              textFontPOOPINS(
                                'Pin status: $strPinStatus',
                                Colors.green,
                                14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ]
                    ]
                  ],
                ),
              ),
        strCardStatus == 'ClosedByCustomer'
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(18.0),
                child: NeoPopTiltedButton(
                  isFloating: true,
                  onTapUp: () {
                    if (kDebugMode) {
                      print('CLICKED ==> CHECK CARD NUMBER');
                      print(widget.cardData['id']);
                      print(storeCustomerToken);
                    }
                    // depositMoney(
                    //   'cardNumber',
                    //   'expiryDate',
                    //   'cvv',
                    //   10,
                    //   'currency',
                    //   'accountId',
                    // );
                    // makePurchase();

                    strSelectType = '2';
                    //
                    showLoadingUI(context, 'please wait...');
                    fetchCustomerToken(
                      storeCustomerFullData['data']['customerId'].toString(),
                    );
                  },
                  decoration: NeoPopTiltedButtonDecoration(
                    color: const Color.fromRGBO(255, 235, 52, 1),
                    plunkColor: hexToColor(appORANGEcolorHexCode),
                    shadowColor: const Color.fromRGBO(36, 36, 36, 1),
                    showShimmer: true,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70.0,
                      vertical: 15,
                    ),
                    child: textFontPOOPINS(
                      'Display card number ',
                      Colors.black,
                      14.0,
                    ),
                  ),
                ),
              ),
        //
        const Spacer(),
        const Divider(thickness: 0.2),

        strCardStatus == 'ClosedByCustomer'
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(
                  top: 6.0,
                  bottom: 4.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: NeoPopTiltedButton(
                  color: Colors.blue[100],
                  onTapUp: () {
                    if (kDebugMode) {
                      print('CLICKED ==> CHECK LIMITS');
                    }
                    fetchCardsLimits();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80.0,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        svgImage(
                          'lock',
                          16.0,
                          16.0,
                        ),
                        const SizedBox(width: 10.0),
                        textFontPOOPINS(
                          'Check Limits and Spends',
                          Colors.black,
                          12.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

        const Divider(thickness: 0.2),

        strCardStatus == 'ClosedByCustomer'
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(
                  top: 6.0,
                  bottom: 4.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: NeoPopTiltedButton(
                  color: strCardStatus == 'Frozen'
                      ? hexToColor(appORANGEcolorHexCode)
                      : Colors.greenAccent,
                  onTapUp: () {
                    if (kDebugMode) {
                      print('CLICKED ==> FREEZE UNFREEZE CARD');
                    }
                    if (strCardStatus == 'Frozen') {
                      showUnfreezeCardDialog(context);
                    } else {
                      showFreezeCardDialog(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80.0,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        svgImage(
                          'card',
                          16.0,
                          16.0,
                        ),
                        const SizedBox(width: 10.0),
                        Column(
                          children: [
                            if (strCardStatus == 'Frozen') ...[
                              textFontPOOPINS(
                                'Unfreeze card',
                                Colors.black,
                                12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ] else ...[
                              textFontPOOPINS(
                                'Freeze card',
                                Colors.black,
                                12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ]
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

        //
        // const Spacer(),
        strCardStatus == 'ClosedByCustomer'
            ? const SizedBox()
            : const Divider(thickness: 0.2),
        strCardStatus == 'ClosedByCustomer'
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(
                  top: 6.0,
                  bottom: 14.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: NeoPopTiltedButton(
                  color: const Color.fromARGB(255, 231, 123, 116),
                  onTapUp: () {
                    if (kDebugMode) {
                      print('CLICKED ==> CLOSE CARD');
                    }

                    closeCard(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80.0,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        svgImage(
                          'card',
                          16.0,
                          16.0,
                        ),
                        const SizedBox(width: 10.0),
                        textFontPOOPINS('Close card', Colors.black, 14.0)
                      ],
                    ),
                  ),
                ),
              ),

        //
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> makePurchase() async {
    try {
      var url = Uri.parse('https://api.s.unit.sh/sandbox/purchases');
      var token = TESTING_TOKEN;

      var payload = json.encode({
        'data': {
          'type': 'purchaseTransaction',
          'attributes': {
            'amount': 1000,
            'direction': 'Debit',
            'merchantName': 'Apple Inc.',
            'merchantType': 1000,
            'merchantLocation': 'Cupertino, CA',
            'coordinates': {
              'longitude': -77.0364,
              'latitude': 38.8951,
            },
            'last4Digits': '9146',
            'recurring': false,
          },
          'relationships': {
            'account': {
              'data': {
                'type': 'depositAccount',
                'id': '3485680',
              },
            },
          },
        },
      });

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/vnd.api+json',
          'Authorization': 'Bearer $token',
        },
        body: payload,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Purchase successful!');
          print(response.body);
        }
        // Handle the response data
      } else {
        if (kDebugMode) {
          print('Purchase failed with status code: ${response.statusCode}');
          print(response.body);
        }
        // Handle error response
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error making purchase: $e');
      }
    }
  }

  Future<void> depositMoney(String cardNumber, String expiryDate, String cvv,
      double amount, String currency, String accountId) async {
    try {
      var url = Uri.parse('https://api.s.unit.sh/payments');
      if (kDebugMode) {
        print(url);
      }

      var payload = {
        'card_number': 4242424242424242,
        'expiry_date': expiryDate,
        'cvv': cvv,
        'amount': amount,
        'currency': currency,
        'account_id': accountId
      };

      var response = await http.post(url, body: json.encode(payload), headers: {
        'Content-Type': 'application/vnd.api+json',
        'Authorization': 'Bearer $TESTING_TOKEN',
      });

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deposit successful!');
          print(response.body);
        }
        // Handle the response data
      } else {
        if (kDebugMode) {
          print('Deposit failed with status code: ${response.statusCode}');
          print(response.body);
        }
        // Handle error response
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error depositing money: $e');
      }
    }
  }

  // close card
  void closeCard(BuildContext context) {
    areYouSureCloseCardPopup(context,
        message: 'Are you sure you want to close this card permanently ?',
        onDismiss: () {
      debugPrint('Dismiss');
    }, onFreeze: () async {
      debugPrint('close card');
      showLoadingUI(context, 'please wait...');
      bool closeStatus = await CardCloseService.closeMyCard(storeCardId);
      if (kDebugMode) {
        print(closeStatus);
      }
      Navigator.pop(context);
      Navigator.pop(context, 'reload_screen');
    });
  }

  void showFreezeCardDialog(BuildContext context) {
    areYouSureFreezeCardPopup(
      context,
      type: '1',
      message: 'Are you sure you want to freeze your card ?',
      onDismiss: () {
        // Your dismiss action here
        if (kDebugMode) {
          print('Card freeze dismissed');
        }

        // Navigator.pop(context);
      },
      onFreeze: () async {
        // Your freeze action here
        if (kDebugMode) {
          print('Card frozen');
        }
        showLoadingUI(context, 'please wait...');
        bool freezeStatus =
            await CardAllFunctionsService.freezeMyCard(storeCardId);

        if (kDebugMode) {
          print(freezeStatus);
        }
        Navigator.pop(context);
        Navigator.pop(context, 'reload_screen');
      },
    );
  }

  void showUnfreezeCardDialog(BuildContext context) {
    areYouSureFreezeCardPopup(
      context,
      type: '2',
      message: 'Are you sure you want to unfreeze your card ?',
      onDismiss: () {
        // Your dismiss action here
        if (kDebugMode) {
          print('Card freeze dismissed');
        }
      },
      onFreeze: () async {
        // Your freeze action here
        if (kDebugMode) {
          print('Card unfrozen');
        }
        showLoadingUI(context, 'please wait...');

        bool freezeStatus =
            await CardAllFunctionsService.unFreezeMyCard(storeCardId);

        if (kDebugMode) {
          print(freezeStatus);
        }
        Navigator.pop(context);
        Navigator.pop(context, 'reload_screen');
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // FETCH CUSTOMER TOKEN
  Future<void> fetchCustomerToken(String customerID) async {
    String? token =
        await CreateCustomerTokenService().getCustomerToken(customerID);
    if (kDebugMode) {
      print('============= TOKEN ==============');
      print('Customer Token: $token');
      print('===================================');
    }

    // create for token verification
    createCustomerTokenForVerification(customerID);
  }

  // card limit
  Future<void> fetchCardsLimits() async {
    showLoadingUI(context, 'fetching...');
    final response = await CheckCardLimitService.checkCardLimit(storeCardId);
    if (kDebugMode) {
      print('============= CARD LIMIT ==============');
      print(response);
      print('===================================');
    }
    Navigator.pop(context);
    _showBottomSheet(response);
  }

  void _showBottomSheet(Map<String, dynamic> response) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  textFontPOOPINS(
                    'Card Limits',
                    Colors.black,
                    20.0,
                    fontWeight: FontWeight.w800,
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      textFontPOOPINS('Daily Withdrawal', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['limits']
                                    ['dailyWithdrawal']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  Row(
                    children: [
                      textFontPOOPINS('Daily Purchase', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['limits']
                                    ['dailyPurchase']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  Row(
                    children: [
                      textFontPOOPINS('Monthly Withdrawal', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['limits']
                                    ['monthlyWithdrawal']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  Row(
                    children: [
                      textFontPOOPINS('Monthly Purchase', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['limits']
                                    ['monthlyPurchase']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  const SizedBox(height: 20),
                  textFontPOOPINS(
                    'Daily Totals',
                    Colors.black,
                    20.0,
                    fontWeight: FontWeight.w800,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      textFontPOOPINS('Withdrawals', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['dailyTotals']
                                    ['withdrawals']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  Row(
                    children: [
                      textFontPOOPINS('Deposits', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['dailyTotals']
                                    ['deposits']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  Row(
                    children: [
                      textFontPOOPINS('Purchases', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['dailyTotals']
                                    ['purchases']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  Row(
                    children: [
                      textFontPOOPINS('Card Transactions', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['dailyTotals']
                                    ['cardTransactions']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  // monthly spents
                  const SizedBox(height: 20),
                  textFontPOOPINS(
                    'Monthly Totals',
                    Colors.black,
                    20.0,
                    fontWeight: FontWeight.w800,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      textFontPOOPINS('Withdrawals', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['monthlyTotals']
                                    ['withdrawals']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  Row(
                    children: [
                      textFontPOOPINS('Deposits', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['monthlyTotals']
                                    ['deposits']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  Row(
                    children: [
                      textFontPOOPINS('Purchases', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['monthlyTotals']
                                    ['purchases']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  Row(
                    children: [
                      textFontPOOPINS('Card Transactions', Colors.black, 14.0),
                      const Spacer(),
                      textFontPOOPINS(
                        COUNTRY_CURRENCY +
                            response['data']['attributes']['monthlyTotals']
                                    ['cardTransactions']
                                .toString(),
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.4),
                  const SizedBox(height: 10),
                  NeoPopTiltedButton(
                    isFloating: true,
                    onTapUp: () {
                      Navigator.pop(context);
                    },
                    decoration: NeoPopTiltedButtonDecoration(
                      color: const Color.fromRGBO(255, 235, 52, 1),
                      plunkColor: hexToColor(appORANGEcolorHexCode),
                      shadowColor: const Color.fromRGBO(36, 36, 36, 1),
                      showShimmer: true,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70.0,
                        vertical: 15,
                      ),
                      child: textFontPOOPINS(
                        'Dismiss',
                        Colors.black,
                        14.0,
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

  //
  Future<void> createCustomerTokenForVerification(String customerID) async {
    String? token = await CreateCustomerTokenService()
        .getCustomerTokenVerification(customerID);
    if (kDebugMode) {
      print('============= VERIFICATION TOKEN ==============');
      print('Customer Verification Token: $token');
      print('===============================================');
    }
    createCustomerTokenAfterVerification(
      customerID,
      token.toString(),
      '000001',
    );
  }

  //
  Future<void> createCustomerTokenAfterVerification(
    String customerID,
    String verificationToken,
    String verificationCode,
  ) async {
    String? tokenAfterAll = await CreateCustomerTokenService()
        .createCustomerTokenAfterVerificationCode(
      strSelectType,
      customerID,
      verificationToken,
      verificationCode,
    );
    if (kDebugMode) {
      print('============= VERIFICATION TOKEN AFTER ALL ==============');
      print('Customer Verification Token AFTER ALL: $tokenAfterAll');
      print('===============================================');
    }
    storeCustomerToken = tokenAfterAll.toString();
    // open browser
    openBrowserToShowCardDetails();
  }

  openBrowserToShowCardDetails() {
    Navigator.pop(context);
    debugPrint(strSelectType);
    if (kDebugMode) {
      print('clicked');
      print('Customer id ==>$storeCustomerId');
      print('Card id ==>${widget.cardData['id']}');
      print('Customer Token after all ==> $storeCustomerToken');
    }
    if (strSelectType == '1') {
      _launchURL(
        '$SET_PIN_URL$storeCustomerId&cardid=${widget.cardData['id']}&customertoken=$storeCustomerToken',
      );
    } else {
      _launchURL(
        '$OPEN_CARD_DETAILS_URL${widget.cardData['id']}&customertoken=$storeCustomerToken',
      );
    }
  }

  // check pin status
  Future<void> fetchCardPinStatus(String cardId) async {
    try {
      Map<String, dynamic> pinStatus =
          await CardPinStatusService().checkIssuedCardPinStatus(cardId);
      if (kDebugMode) {
        print('Pin Status: $pinStatus');
      }
      if (pinStatus.containsKey('attributes') &&
          pinStatus['attributes'].containsKey('status')) {
        String status = pinStatus['attributes']['status'];
        if (kDebugMode) {
          print('Status: $status');
        }
        //

        debugPrint('Card Pin Status ===========> $strCardStatus');
        if (status == 'Set') {
          strPinStatus = 'Set';
        } else {
          strPinStatus = status;
        }

        setState(() {
          pinStatusLoader = false;
        });
        // Handle the status as needed
      } else {
        if (kDebugMode) {
          print('Status attribute not found in response');
        }
      }

      // Handle the pinStatus as needed
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      // Handle the error as needed
    }
  }
}
