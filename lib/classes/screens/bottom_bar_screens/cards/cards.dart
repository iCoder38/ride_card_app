import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/hive/hive.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/widgets/widgets.dart';
import 'package:ride_card_app/classes/service/check_cc_score/check_cc_score.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String data = 'Fetching data...';

  final ApiService _apiService = ApiService();
  final GenerateTokenService _apiServiceGT = GenerateTokenService();

  final TextEditingController _contPanSnn = TextEditingController();
  String yourScore = '';

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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 140,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 240, 240, 240),
              borderRadius: BorderRadius.circular(
                16.0,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 4.0,
                ),
                textFontORBITRON(
                  //
                  TEXT_CREDIT_SCORE,
                  Colors.black,
                  22.0,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                textFontPOOPINS(
                  'Check your current credit score.',
                  const Color.fromARGB(255, 96, 95, 95),
                  14.0,
                  fontWeight: FontWeight.w400,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 24.0, left: 24.0),
                  child: Divider(),
                ),
                GestureDetector(
                  onTap: () {
                    showLoadingUI(context, PLEASE_WAIT);
                    _sendRequestToProfile(context);
                  },
                  child: yourScore != ''
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textFontPOOPINS(
                              'Your score is: ',
                              const Color.fromARGB(255, 121, 120, 120),
                              14.0,
                            ),
                            textFontPOOPINS(
                              yourScore,
                              Colors.black,
                              18.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ],
                        )
                      : textFontPOOPINS(
                          'Check score now >',
                          appREDcolor,
                          14.0,
                          fontWeight: FontWeight.w800,
                        ),
                ),
              ],
            ),
          ),
        ),
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

  void _sendRequestToProfile(context) async {
    debugPrint('API ==> PROFILE');
    var name = '';
    var contactNumner = '';
    var box = await Hive.openBox<MyData>(HIVE_BOX_KEY);
    var myData = box.getAt(0);
    await box.close();

    final parameters = {
      'action': 'profile',
      'userId': myData!.userId,
    };
    if (kDebugMode) {
      print(parameters);
    }
    // return;
    try {
      final response = await _apiService.postRequest(parameters, '');
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];

      if (response.statusCode == 200) {
        debugPrint('PROFILE: RESPONSE ==> SUCCESS');
        //
        if (successMessage == NOT_AUTHORIZED) {
          //
          _apiServiceGT
              .generateToken(
            myData.userId,
            FirebaseAuth.instance.currentUser!.email,
            myData.role,
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            _sendRequestToProfile(context);
          });
        } else {
          //
          debugPrint('SUCCESS');
          var first_name = jsonResponse['data']['fullName'];
          var last_name = jsonResponse['data']['lastName'];
          name = first_name + ' ' + last_name;
          contactNumner = jsonResponse['data']['contactNumber'];
          Navigator.pop(context);
          checkCreditScorePopUpSheet(
            context,
            'message',
            'content',
            name,
            contactNumner,
          );
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('PROFILE: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  void checkCreditScorePopUpSheet(
    BuildContext context,
    String message,
    content,
    String name,
    String contactNumber,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: textFontPOOPINS(
                              'Please check your info and enter your pan/ssn before proceeding.',
                              Colors.black,
                              14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(width: 20.0),
                          textFontPOOPINS(
                            'Name: ',
                            Colors.black,
                            14.0,
                          ),
                          textFontPOOPINS(
                            name,
                            Colors.grey,
                            14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(width: 20.0),
                          textFontPOOPINS(
                            'Mobile: ',
                            Colors.black,
                            14.0,
                          ),
                          textFontPOOPINS(
                            //
                            contactNumber,
                            Colors.grey,
                            14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 22.0,
                      ),
                      textFontPOOPINS(
                        'PAN/SSN',
                        Colors.black,
                        12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextFormField(
                          controller: _contPanSnn,
                          decoration: const InputDecoration(
                            hintText: 'pan/ssn',
                            border: InputBorder.none, // Remove the border
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 10.0,
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pop();
                      //
                      showLoadingUI(context, CHECKING_SCORE_TEXT);
                      //
                      fetchCreditScore2(
                        apiUrl: CC_SCORE_BASE_URL,
                        clientId: CC_SCORE_CLIENT_ID,
                        clientSecret: CC_SCORE_CLIENT_SECRET,
                        moduleSecret: CC_SCORE_MODULE_SECRET,
                        providerSecret: CC_SCORE_PROVIDER_SECRET,
                        name: name, //"BICKY KUMAR",
                        mobile: contactNumber, //"9555536396",
                        inquiryPurpose: "CC",
                        documentType: "PAN",
                        documentId: _contPanSnn.text
                            .toString()
                            .toUpperCase(), //"AAICV0413H",
                      ).then((v) {
                        //
                        if (kDebugMode) {
                          print('CC CHECK SCORE =====> $v');
                          // print(v['status'].runtimeType);
                        }
                        if (v['status'] == null) {
                          debugPrint('am i null');
                        }
                        if (v['status'].toString() == 'FAILURE') {
                          //
                          if (kDebugMode) {
                            print('FAIL');
                          }
                          customToast(
                            v['message'],
                            Colors.redAccent,
                            ToastGravity.BOTTOM,
                          );
                          Navigator.pop(context);
                          Navigator.of(context).pop();
                        } else {
                          debugPrint('SUCCESSFULLY GET');
                          List<dynamic> scoreDetails = v['data']['cCRResponse']
                                  ['cIRReportDataLst'][0]['cIRReportData']
                              ['scoreDetails'];
                          String name = scoreDetails[0]['value'].toString();
                          Navigator.pop(context);
                          Navigator.of(context).pop();
                          //
                          customToast(
                            'Success',
                            Colors.green,
                            ToastGravity.BOTTOM,
                          );
                          setState(() {
                            yourScore = name;
                          });
                        }
                      });
                      //
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: textFontORBITRON(
                          'Check',
                          Colors.black,
                          18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: textFontPOOPINS(
                          'Dismiss',
                          Colors.red,
                          14.0,
                        ),
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