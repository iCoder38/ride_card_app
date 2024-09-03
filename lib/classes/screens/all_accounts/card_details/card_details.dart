import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/neopop.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/stripe/generate_token/generate_token.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/model/model.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/sheet/alreadySavedCardSheet.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/sheet/sheet.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/fee_calculator/fee_calculator.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/get_price.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/model/model.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
// import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/model/model.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/save_get_card.dart';
import 'package:ride_card_app/classes/screens/all_accounts/card_details/alert/alert.dart';
import 'package:ride_card_app/classes/screens/convenience_fee/convenience_fees.dart';
import 'package:ride_card_app/classes/service/UNIT/CARD/check_limit/check_limit.dart';
import 'package:ride_card_app/classes/service/UNIT/CARD/close_card/close_card.dart';

import 'package:ride_card_app/classes/service/UNIT/CARD/freeze_unfreeze_card/freeze_unfreeze_card.dart';

// import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/service/UNIT/CARD/pin_status/pin_status.dart';
import 'package:ride_card_app/classes/service/UNIT/CUSTOMER/customer_token/customer_token.dart';
import 'package:ride_card_app/classes/service/charge_money_from_stripe/charge_money_from_stripe.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key, this.cardData});

  final cardData;

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  //
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  final stripeService = ChargeMoneyStripeService();
  final GenerateTokenService _apiServiceGT = GenerateTokenService();
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
  //
  // FEES AND TAXES
  String feesAndTaxesType = '';
  double feesAndTaxesAmount = 0.0;
  double calculatedFeeAmount = 0.0;
  double totalAmountAfterCalculateFee = 0.0;
  bool removePopLoader = false;
  double showConvenienceFeesOnPopup = 0.0;
  var savedCardDetailsInDictionary;
  var strWhatUserSelect = '';
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
                      print('========================');
                      print('USER CLICKED CLOSED CARD');
                      print('========================');
                    }

                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentTaxAndFeesScreen(
                          // cardData: widget.cardData,
                          cardData: widget.cardData,
                        ),
                      ),
                    );*/

                    strWhatUserSelect = 'close_card';
                    showLoadingUI(context, 'please wait...');
                    getFeesAndTaxes('cardCloseFee');
                    // closeCard(context);
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

  /*Future<void> makePurchase() async {
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
  }*/

  /*Future<void> depositMoney(String cardNumber, String expiryDate, String cvv,
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
  }*/

  /*void _deleteCard(context, String cardId) async {
    debugPrint('API ==> DELETE CARD');
    showLoadingUI(context, 'deleting...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();

    final parameters = {
      'action': 'carddelete',
      'userId': userId,
      'cardId': cardId,
    };
    if (kDebugMode) {
      print(parameters);
    }

    try {
      final response = await _apiService.postRequest(parameters, token);
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = '';
      if (jsonResponse['msg'] == null) {
        //
        successMessage = '';
        if (kDebugMode) {
          print('STATUS ==> $successStatus');
          print(successMessage);
        }
      } else {
        successMessage = jsonResponse['msg'];
        if (kDebugMode) {
          print('STATUS ==> $successStatus');
          print(successMessage);
        }
      }

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');
        //
        if (successMessage == NOT_AUTHORIZED) {
          //
          apiServiceGT
              .generateToken(
            userId,
            FirebaseAuth.instance.currentUser!.email,
            'Member',
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            _deleteCard(context, cardId);
          });
        } else {
          //
          Navigator.pop(context);
          Navigator.pop(context, 'reload_screen');
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
  }*/

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
        freezeUnfreezeCardInEVSApi(context, '0');
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
        freezeUnfreezeCardInEVSApi(context, '1');
      },
    );
  }

  void freezeUnfreezeCardInEVSApi(
    context,
    String type,
  ) async {
    debugPrint('API ==> FREEZE UNFREEZE CARD BY EVS API');
    // showLoadingUI(context, 'deleting...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    final parameters = {
      'action': 'cardedit',
      'userId': userId,
      'unit_card_id': storeCardId.toString(),
      'status': type, // 0 = freeze
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
      String successMessage = '';
      if (jsonResponse['msg'] == null) {
        //
        successMessage = '';
        if (kDebugMode) {
          print('STATUS ==> $successStatus');
          print(successMessage);
        }
      } else {
        successMessage = jsonResponse['msg'];
        if (kDebugMode) {
          print('STATUS ==> $successStatus');
          print(successMessage);
        }
      }

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');
        //
        if (successMessage == NOT_AUTHORIZED) {
          //
          apiServiceGT
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
            if (type == '1') {
              freezeUnfreezeCardInEVSApi(context, '1');
            } else {
              freezeUnfreezeCardInEVSApi(context, '0');
            }
          });
        } else {
          //
          Navigator.pop(context);
          Navigator.pop(context, 'reload_screen');
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
                            convertCentsToDollarsAndCents(response['data']
                                    ['attributes']['dailyTotals']['withdrawals']
                                .toString()),
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
                            convertCentsToDollarsAndCents(response['data']
                                    ['attributes']['dailyTotals']['deposits']
                                .toString()),
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
                            convertCentsToDollarsAndCents(response['data']
                                    ['attributes']['dailyTotals']['purchases']
                                .toString()),
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
                            convertCentsToDollarsAndCents(response['data']
                                        ['attributes']['dailyTotals']
                                    ['cardTransactions']
                                .toString()),
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
                            convertCentsToDollarsAndCents(response['data']
                                        ['attributes']['monthlyTotals']
                                    ['withdrawals']
                                .toString()),
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
                            convertCentsToDollarsAndCents(response['data']
                                    ['attributes']['monthlyTotals']['deposits']
                                .toString()),
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
                            convertCentsToDollarsAndCents(response['data']
                                    ['attributes']['monthlyTotals']['purchases']
                                .toString()),
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
                            convertCentsToDollarsAndCents(response['data']
                                        ['attributes']['monthlyTotals']
                                    ['cardTransactions']
                                .toString()),
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

  // TAXES AND FEES
  void getFeesAndTaxes(userSelectType) async {
    ApiServiceToGetFeesAndTaxes apiService = ApiServiceToGetFeesAndTaxes();

    List<FeeData>? feeList = await apiService.fetchFeesAndTaxes();

    if (feeList != null) {
      for (var fee in feeList) {
        if (kDebugMode) {
          print(
            'ID: ${fee.id}, Name: ${fee.name}, Type: ${fee.type}, Amount: ${fee.amount}',
          );
        }
        if (fee.name == userSelectType) {
          // account closing
          debugPrint('===========================');
          debugPrint('====> $userSelectType <====');
          debugPrint('===========================');
          if (fee.type == TAX_TYPE_PERCENTAGE) {
            feesAndTaxesType = fee.type.toString();
            feesAndTaxesAmount = double.parse(fee.amount.toString());
            showConvenienceFeesOnPopup = (feesAndTaxesAmount * 10) / 100;
            totalAmountAfterCalculateFee = (feesAndTaxesAmount * 10) / 100;
          } else {
            debugPrint(fee.type);
            feesAndTaxesType = fee.type.toString();
            feesAndTaxesAmount = double.parse(fee.amount.toString());
            showConvenienceFeesOnPopup = feesAndTaxesAmount;
            // (feesAndTaxesAmount * 10) / 100;
            totalAmountAfterCalculateFee = feesAndTaxesAmount;
            // (feesAndTaxesAmount * 10) / 100;
            // return;
          }
        }
      }
      if (feesAndTaxesType == TAX_TYPE_PERCENTAGE) {
        String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
        showConvenienceFeesOnPopup = double.parse(formattedValue.toString());
        // if (kDebugMode) {
        //   print(showConvenienceFeesOnPopup);
        // }
        // FEES CALCULATOR
        calculateFeesAndReturnValue();
      } else {
        if (kDebugMode) {
          // print(showConvenienceFeesOnPopup);
          // String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
          // print(formattedValue);
        }
        String formattedValue = showConvenienceFeesOnPopup.toStringAsFixed(2);
        showConvenienceFeesOnPopup = double.parse(formattedValue.toString());
        // FEES CALCULATOR
        calculateFeesAndReturnValue();
      }
    } else {
      if (kDebugMode) {
        print('Failed to retrieve fee data.');
      }
    }
  }

  calculateFeesAndReturnValue() {
    double calculatedFee = FeeCalculator.calculateFee(
      feesAndTaxesType,
      feesAndTaxesAmount,
    );
    totalAmountAfterCalculateFee = calculatedFee;
    if (kDebugMode) {
      print(totalAmountAfterCalculateFee);
    }
    //
    Navigator.pop(context);
    if (strWhatUserSelect == 'close_card') {
      closeCardPopUp(context, showConvenienceFeesOnPopup);
      // areYourSurecloseAccountPopup(context, showConvenienceFeesOnPopup);
    } else if (strWhatUserSelect == 'unfreeze_bank_account') {
      // areYourSureUnfreezeAccountPopup(context, showConvenienceFeesOnPopup);
    }
  }

  // POPUP: close card
  void closeCardPopUp(BuildContext context, showConvenienceFee) {
    areYouSureCloseCardPopup(context,
        message: 'Are you sure you want to close this card permanently ?',
        subMessage:
            'This action can not be undone and you are not able to use this card again.',
        showConvenienceFees: showConvenienceFee, onDismiss: () {
      debugPrint('Dismiss');
    }, onFreeze: () async {
      debugPrint('close card');
      // showLoadingUI(context, 'please wait...');
      // openCardBottomSheet(context);
      pushToConvenienceFeeScreen(
        context,
        'Close card',
        'cardCloseFee',
      );
      /**/
      // _deleteCard(context, storeCardId);
    });
  }

  // OPEN BOTTOM SHEET WITH ENTER CARD DETAILS
  void openCardBottomSheet(BuildContext context) async {
    final result = await showCardBottomSheet(context);

    if (result == null) return;

    if (result['topButtonClicked'] == true) {
      await handleTopButtonClicked(context);
    } else {
      final cardDetails = result['cardDetails'] as CardDetailsForTaxAndFees;
      final saveCard = result['saveCard'] as bool;
      await processCardPayment(context, cardDetails, saveCard);
    }
  }

  // USER CLICK SAVED CARD BUTTON
  Future<void> handleTopButtonClicked(BuildContext context) async {
    final savedCardDetails = await getUserSavedCardDetails(loginUserId());

    if (savedCardDetails != false) {
      savedCardDetailsInDictionary = savedCardDetails;
      Timer(const Duration(milliseconds: 300), handleTimeout);
    } else {
      debugPrint('No card is saved in Firebase');
    }
  }

  // ALL ENTERED OR SAVED CARD DETAILS RETURN
  Future<void> processCardPayment(BuildContext context,
      CardDetailsForTaxAndFees cardDetails, bool saveCard) async {
    if (kDebugMode) {
      print('Cardholder Name: ${cardDetails.cardholderName}');
      print('Card Number: ${cardDetails.cardNumber}');
      print('Exp. Month: ${cardDetails.expMonth}');
      print('Exp. Year: ${cardDetails.expYear}');
      print('CVV: ${cardDetails.cvv}');
      print('Save Card: $saveCard');
    }

    processPayment(
      context,
      cardDetails.cardholderName,
      cardDetails.cardNumber,
      cardDetails.expMonth,
      cardDetails.expYear,
      cardDetails.cvv,
      totalAmountAfterCalculateFee,
      saveCard,
    );
  }

  // IF USER CLICK ON SAVED CARD SO THAT CALLED
  void handleTimeout() async {
    final cardDetails = SavedCardDetails(
      cardNumber: savedCardDetailsInDictionary['cardNumber'],
      cardholderName: savedCardDetailsInDictionary['cardHolderName'],
      expMonth: savedCardDetailsInDictionary['cardExpMonth'],
      expYear: savedCardDetailsInDictionary['cardExpYear'],
      cvv: '', // CVV will be input by the user
    );

    final updatedCardDetails = await showCardDetailsDialog(
      context,
      cardDetails,
    );

    if (updatedCardDetails != null) {
      if (kDebugMode) {
        print('Cardholder Name: ${updatedCardDetails.cardholderName}');
        print('Card Number: ${updatedCardDetails.cardNumber}');
        print('Exp. Month: ${updatedCardDetails.expMonth}');
        print('Exp. Year: ${updatedCardDetails.expYear}');
        print('CVV: ${updatedCardDetails.cvv}');
        // print('SAVED: ${updatedCardDetails.saveCard}');
      }

      processPayment(
        context,
        updatedCardDetails.cardholderName,
        updatedCardDetails.cardNumber,
        updatedCardDetails.expMonth,
        updatedCardDetails.expYear,
        updatedCardDetails.cvv,
        totalAmountAfterCalculateFee,
        true,
        // convertDollarToCentsInDouble(totalAmountAfterCalculateFee),
      );
    }
  }

  void processPayment(
    BuildContext context,
    name,
    number,
    month,
    year,
    cvv,
    amount,
    cardSavedStatus,
  ) async {
    debugPrint('STRIPE: Create token hit');

    final token = await createStripeToken(
        cardNumber: number.toString(),
        expMonth: month.toString(),
        expYear: year.toString(),
        cvc: cvv.toString());

    // Use the token for further processing, such as making a payment
    if (kDebugMode) {
      print('Received token: $token');
      print('Stripe amount to send: $amount');
      print('Stripe amount to send: $cardSavedStatus');
    }

    if (cardSavedStatus == true) {
      final card = CardModel(
        userId: loginUserId(),
        cardHolderName: loginUserName(),
        cardNumber: number.toString(),
        cardExpMonth: month.toString(),
        cardExpYear: year.toString(),
        cardId: const Uuid().v4(),
        cardStatus: true,
      );

      final success = await SavedCardService.saveUserCardInRealDB(card);
      if (success) {
        debugPrint('Firebase: Card saved successfully');
        // API: Charge amount
      } else {
        debugPrint('Failed to save card');
      }
    } else {}
    chargeMoneyFromStripeAndAddToEvsServer(
      amount,
      token,
      cardSavedStatus,
    );
  }

  chargeMoneyFromStripeAndAddToEvsServer(
    amount,
    token,
    getCardSavedStatus,
  ) async {
    debugPrint('API: Charge amount: Send stripe data to server.');
    showLoadingUI(context, 'Please wait...');
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();
    //
    if (kDebugMode) {
      print('===================================');
      print('CONVENIENCE FEES IS: ====> $amount');
      print('===================================');
    }
    final response = await stripeService.chargeMoneyFromStripeAfterGettingToken(
      amount: amount,
      stripeCardToken: token,
      type: feesAndTaxesType,
    );

    if (kDebugMode) {
      print(response!.message);
    }
    if (response != null) {
      if (response.status == 'Fail') {
        debugPrint('API: FAILS.');
        Navigator.pop(context);
        customToast(
          response.message,
          Colors.redAccent,
          ToastGravity.BOTTOM,
        );
      } else if (response.status == 'NOT_AUTHORIZED') {
        debugPrint('CHARGE AMOUNT API IS NOT AUTHORIZE. PLEASE AUTHORIZE');
        _apiServiceGT
            .generateToken(
          userId,
          loginUserEmail(),
          roleIs,
        )
            .then((v) {
          if (kDebugMode) {
            print('TOKEN ==> $v');
          }
          // again click
          chargeMoneyFromStripeAndAddToEvsServer(
            amount,
            token,
            getCardSavedStatus,
          );
        });
        return;
      } else {
        debugPrint(
          'Success: Payment deducted from stripe. Now create UNIT bank account',
        );
        //

        // NOE CREATE A UNIT BANK ACCOUNT
        debugPrint('======================================');
        debugPrint('DO MAIN FUNCTION HERE AFTER EVERYTHING');
        debugPrint('======================================');
        if (strWhatUserSelect == 'close_card') {
          // close card
          // closeCardFromUnit();
        } else if (strWhatUserSelect == 'unfreeze_card') {
          // unfreeze bank account
          //  _handleUnfreezeAccount();
        }
      }
    } else {
      Navigator.pop(context);
    }
  }

  // UNIT: Close card permanently
  closeCardFromUnit() async {
    bool closeStatus = await CardCloseService.closeMyCard(storeCardId);
    if (kDebugMode) {
      print(closeStatus);
    }
    // Navigator.pop(context);
    Navigator.pop(context, 'reload_screen');
  }

  Future<void> pushToConvenienceFeeScreen(
    BuildContext context,
    String title,
    String feeType,
  ) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConvenienceFeesChargesScreen(
          title: title, //'Close my account',
          feeType: feeType, // 'accountClosingFee',
        ),
      ),
    );

    if (!mounted) return;
    //
    if (result == REFRESH_CONVENIENCE_FEES) {
      if (kDebugMode) {
        print(result);
        print(feeType);
      }

      closeCardFromUnit();
    }
  }
}
