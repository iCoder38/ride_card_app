// import 'package:http/http.dart' as http;
// import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
// import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
// import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:ride_card_app/classes/service/UNIT/CARD/pin_status/pin_status.dart';

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
    // FETCH AND CHECK PIN STATUS
    fetchCardPinStatus(widget.cardData['id']); // card id
    super.initState();
  }

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
}
