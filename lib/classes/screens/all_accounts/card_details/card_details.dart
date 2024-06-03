import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
// import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
// import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/service/UNIT/CARD/pin_status/pin_status.dart';
import 'package:ride_card_app/classes/service/UNIT/CUSTOMER/customer_token/customer_token.dart';
import 'package:uuid/uuid.dart';

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key, this.cardData});

  final cardData;

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  //
  var strPinStatus = '';
  bool pinStatusLoader = true;
  @override
  void initState() {
    if (kDebugMode) {
      print('======== CARD DATA ==============');
      print(widget.cardData);
      print(widget.cardData['id']);
      print('=================================');
    }
    // test
    fetchCustomerToken();
    // FETCH AND CHECK PIN STATUS
    fetchCardPinStatus(widget.cardData['id']); // card id
    super.initState();
  }

  Future<void> fetchCustomerToken() async {
    String customerID = '1992974'; // Replace with actual customer ID
    String? token =
        await CreateCustomerTokenService().getCustomerToken(customerID);
    if (kDebugMode) {
      print('============= TOKEN ==============');
      print('Customer Token: $token');
      print('===================================');
    }
    // _submitFormToSetPin(token, widget.cardData['id']);
    // dummy(token, widget.cardData['id']);
    // _submitForm(widget.cardData['id'], token);
    getCustomerToken(token, customerID);
    // Handle the token as needed
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
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _UIKitCardDetailsAfterBG(context),
      ),
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
                  widget.cardData['attributes']['status'].toString() == 'Active'
                      ? textFontPOOPINS(
                          //
                          widget.cardData['attributes']['status'].toString(),
                          Colors.green,
                          10.0,
                          fontWeight: FontWeight.w700,
                        )
                      : textFontPOOPINS(
                          //
                          'Closed',
                          Colors.redAccent,
                          10.0,
                          fontWeight: FontWeight.w700,
                        ),
                ],
              ),
              onTap: () {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardDetailsScreen(
                      cardData: widget.cardData,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              if (pinStatusLoader == true) ...[
                textFontPOOPINS(
                  'Pin: ...',
                  Colors.white,
                  14.0,
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
                          if (kDebugMode) {
                            print('CLICKED ==> NOT SET');
                          }
                        },
                        child: Text(
                          'Not Set',
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                              decorationThickness: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  textFontPOOPINS(
                    'Pin status: $pinStatusLoader',
                    Colors.white,
                    14.0,
                  ),
                ]
              ]
            ],
          ),
        ),
      ],
    );
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
        strPinStatus = status;
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

  /*Future<void> _submitFormToSetPin(customerToken, cardID) async {
    final apiUrl = Uri.parse('$SANDBOX_LIVE_URL/cards/$cardID/secure-data/pin');
    print(apiUrl);
    // return;
    try {
      final response = await http.post(
        apiUrl.replace(path: apiUrl.path.replaceAll('{CARD_ID}', cardID)),
        headers: {
          'Content-Type': 'application/vnd.api+json',
          'Authorization': 'Bearer $customerToken',
        },
        body: <String, dynamic>{
          'data': {
            'attributes': {'pin': '1234'}
          }
        },
      );

      // Handle response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (error) {
      print('Error: $error');
      // Handle error
    }
  }*/
  void _submitForm(cardId, token) async {
    final String pin = '12345';

    final Map<String, dynamic> requestBody = {
      "data": {
        "attributes": {
          "pin": pin,
        }
      }
    };

    final String apiUrl = '$SANDBOX_LIVE_URL/cards/$cardId/secure-data/pin';

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/vnd.api+json",
        'Authorization': 'Bearer $TESTING_TOKEN',
        // "Authorization": "Bearer $token",
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print("PIN set successfully!");
      print(response.body);
    } else {
      print("Failed to set PIN");
      print(response.body);
    }
  }

  Future<String?> dummy(customerToken, String cardID) async {
    debugPrint('========== CUSTOMER TOKEN URL ================');
    final url = Uri.parse('$SANDBOX_LIVE_URL/cards/$cardID/secure-data/pin');
    if (kDebugMode) {
      print(url);
    }
    debugPrint('==========================================');

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
      // 'Authorization': 'Bearer $customerToken',
    };

    // Define the request body
    Map<String, dynamic> requestBody = {
      "data": {
        'attributes': {
          "scope": "cards-sensitive-write",
          'pin': '1234',
        }
      }
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 201) {
        // If the server returns a 201 Created response
        if (kDebugMode) {
          debugPrint('========== CUSTOMER TOKEN ================');
          print(json.decode(response.body));
          debugPrint('===================================================');
        }
        final responseData = json.decode(response.body);
        return responseData['data']['attributes']['token'];
      } else {
        if (kDebugMode) {
          final jsonData = json.decode(response.body);
          print('Error creating customer token: $jsonData');
        }
        return null;
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      print('Error: $error');
      return null;
    }
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  Future<String?> getCustomerToken(token, String customerID) async {
    debugPrint('========== CUSTOMER TOKEN URL 2.0 ================');
    print(token);
    final url = Uri.parse('$SANDBOX_LIVE_URL/customers/$customerID/token');

    if (kDebugMode) {
      print(url);
    }
    debugPrint('==========================================');

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    // Define the request body
    Map<String, dynamic> requestBody = {
      "data": {
        "type": 'customerToken',
        "attributes": {
          "scope": "cards-sensitive-write",
          "verificationToken": token,
          "verificationCode": "203130",
          // "scope": "cards-sensitive-write",
        },
      }
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 201) {
        // If the server returns a 201 Created response
        if (kDebugMode) {
          debugPrint('========== CUSTOMER TOKEN ================');
          print(json.decode(response.body));
          debugPrint('===================================================');
        }
        final responseData = json.decode(response.body);
        return responseData['data']['attributes']['token'];
      } else {
        if (kDebugMode) {
          final jsonData = json.decode(response.body);
          print('Error creating customer token: $jsonData');
        }
        return null;
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      print('Error: $error');
      return null;
    }
  }
}
