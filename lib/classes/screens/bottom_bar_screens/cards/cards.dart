import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/widgets/widgets.dart';
import 'package:ride_card_app/classes/service/check_cc_score/check_cc_score.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String data = 'Fetching data...';

  final String clientId =
      'kcPZGZqmj4dlsuGdkQ75uBQxLEGIQhCL'; // Replace with your actual client ID
  final String baseUrl =
      'https://api.equifax.com/personal/consumer-data-suite/v1/creditReport'; // Replace with the actual Equifax API endpoint
  String creditScore = 'Fetching credit score...';
  //
  @override
  void initState() {
    super.initState();
    // fetchCreditScore();
  }

  /*Future<void> fetchCreditScore() async {
    debugPrint('CHECK');
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Client-Id': clientId,
        },
        body: jsonEncode({
          'firstName': 'Dishant', // Replace with actual first name
          'lastName': 'Rajput', // Replace with actual last name
          'panCardNumber': 'AYQP56608H', // Replace with actual SSN
          'dateOfBirth': '1992-06-06', // Replace with actual DOB
          // Add other necessary parameters
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('success');
        final data = jsonDecode(response.body);
        setState(() {
          creditScore = 'Your credit score is: ${data['creditScore']}';
        });
      } else {
        throw Exception('Failed to fetch credit score');
      }
    } catch (error) {
      setState(() {
        creditScore = 'Failed to fetch credit score: $error';
      });
    }
  }*/

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
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _UIKitCardsAfterBG(context),
      ),
    );
  }

  Widget _UIKitCardsAfterBG(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 80.0,
        ),
        customNavigationBarForMenu(
          TEXT_NAVIGATION_TITLE_DASHBOARD,
          _scaffoldKey,
        ),
        //
        widgetCardsCreditScore(context),
        //
        widgetDashboardUpperDeck(context),
        const SizedBox(
          height: 20.0,
        ),
        widgetDashbaordLowerDeck(),

        Padding(
          padding: const EdgeInsets.all(22.0),
          child: GestureDetector(
            onTap: () {
              //
              if (kDebugMode) {
                print('object');
                // fetchCreditScore();
              }
              // fetchCreditScore();
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  14.0,
                ),
                border: Border.all(
                  color: appREDcolor,
                  width: 2.0,
                ),
              ), // 218 71 50
              child: Center(
                child: textFontPOOPINS(
                  //
                  TEXT_BUSINESS,
                  Colors.white,
                  18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 22.0,
            right: 22.0,
          ),
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const RegisterScreen()),
              // );
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(
                  234,
                  158,
                  70,
                  1,
                ),
                borderRadius: BorderRadius.circular(
                  14.0,
                ),
              ), // 218 71 50
              child: Center(
                child: textFontPOOPINS(
                  //
                  'Get a ride',
                  Colors.white,
                  18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /*Future<void> fetchCreditScore() async {
    print('object 2 ');
    try {
      // Call Equifax service to fetch credit score
      double score = await equifaxService.fetchCreditScore();
      setState(() {
        creditScore = 'Your credit score is: $score';
      });
    } catch (e) {
      setState(() {
        creditScore = 'Failed to fetch credit score: $e';
      });
    }
  }*/

  /*Future<void> fetchData2() async {
    try {
      Map<String, dynamic> result = await equifaxService.fetchEquifaxData();
      setState(() {
        data = result.toString();
      });
    } catch (e) {
      setState(() {
        data = 'Error: $e';
      });
    }
  }*/
// kcPZGZqmj4dlsuGdkQ75uBQxLEGIQhCL
  void fetchCreditScore() async {
    fetchCreditScore2(
      apiUrl: CC_SCORE_BASE_URL,
      clientId: CC_SCORE_CLIENT_ID,
      clientSecret: CC_SCORE_CLIENT_SECRET,
      moduleSecret: CC_SCORE_MODULE_SECRET,
      providerSecret: CC_SCORE_PROVIDER_SECRET,
      name: "BICKY KUMAR",
      mobile: "9555536396",
      inquiryPurpose: "CC",
      documentType: "PAN",
      documentId: "AAICV0413H",
    ).then((v) {
      //
      print('=====> $v');
    });
  }
}

// 92B73E0AC4D94773A890FEA38AEEBE23

/*
"reference_id": "ABCDEF41234235671222",
    "consent": true,
    "consent_purpose": "for bank verification only",
    "name": "BICKY KUMAR",
    "date_of_birth": "1992-06-06",
    "address_type": "H",
    "address": "flat 102 plot 39",
    "pincode": "110075",
    "mobile": "8929963020",
    "inquiry_purpose": "CC",
    "document_type": "PAN",
    "document_id": "AAICV0413H"
*/