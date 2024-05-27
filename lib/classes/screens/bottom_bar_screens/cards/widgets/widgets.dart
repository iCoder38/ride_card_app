import 'dart:io';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/hive/hive.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/screens/all_cards/all_cards.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ride_card_app/classes/service/check_cc_score/check_cc_score.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';

// class SecureStorage {
//   final _storage = FlutterSecureStorage();

//   Future<void> write(String key, String value) async {
//     await _storage.write(key: key, value: value);
//   }

//   Future<String?> read(String key) async {
//     return await _storage.read(key: key);
//   }

//   Future<void> delete(String key) async {
//     await _storage.delete(key: key);
//   }
// }

/*class EquifaxService {
  final String clientId =
      'kcPZGZqmj4dlsuGdkQ75uBQxLEGIQhCL'; // Replace with your actual client ID
  final String baseUrl =
      'https://api.equifax.com/personal/consumer-data-suite/v1/creditReport'; // Replace with the actual Equifax API sandbox endpoint

  Future<Map<String, dynamic>> fetchEquifaxData() async {
    print('hmm');
    final response = await http.get(
      Uri.parse('$baseUrl?client_id=$clientId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data from Equifax');
    }
  }
}*/
final ApiService _apiService = ApiService();
GenerateTokenService _apiServiceGT = GenerateTokenService();
final TextEditingController _contPanSnn = TextEditingController();

Widget widgetCardsCreditScore(context) {
  return Padding(
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
            child: textFontPOOPINS(
              'Check score now >',
              appREDcolor,
              14.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );
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
                        print(v.runtimeType);
                      }

                      RegExp regExp1 = RegExp(r'"status":\s*"([^"]+)"');
                      RegExp regExp = RegExp(r'"providerMessage":\s*"([^"]+)"');
                      Match? match = regExp.firstMatch(v);
                      Match? match1 = regExp1.firstMatch(v);
                      if (match1 != null) {
                        String providerMessage = match1.group(1)!;
                        if (match != null) {
                          String providerMessage1 = match.group(1)!;
                          if (providerMessage == 'FAILURE') {
                            //
                            customToast(
                              providerMessage1,
                              Colors.redAccent,
                              ToastGravity.BOTTOM,
                            );
                            Navigator.pop(context);
                            Navigator.of(context).pop();
                          }
                        }

                        // print(providerMessage);
                      }

                      /*RegExp regExp = RegExp(r'"providerMessage":\s*"([^"]+)"');
                      Match? match = regExp.firstMatch(v);
                      if (match != null) {
                        String providerMessage = match.group(1)!;
                        print('Provider Message: $providerMessage');
                      } else {
                        print('Provider Message not found');
                      }*/
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

checkCreditScore() async {
  // var headers = {'Content-Type': 'application/json'};
  // var request = http.Request(
  //     'POST',
  //     Uri.parse(
  //         'https://api.equifax.com/personal/consumer-data-suite/v1/creditReport'));
  // request.body = json.encode({
  //   "name": "Dishant Rajput",
  //   "pan": "AYQPR6608H",
  //   "mobile": "8929963020",
  //   "consent": "Y"
  // });
  // request.headers.addAll(headers);

  // http.StreamedResponse response = await request.send();

  // if (response.statusCode == 200) {
  //   print(await response.stream.bytesToString());
  // } else {
  //   print(response.reasonPhrase);
  // }
}
/*
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
*/
Widget widgetDashboardUpperDeck(context) {
  return Row(
    children: [
      const SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: GestureDetector(
          onTap: () {
            //
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllCardsScreen()),
            );
          },
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1E1E1E), // Darker color
                  Color(0xFF3C3C3C), // Slightly lighter color
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: Image.asset(
                      'assets/images/menu_cards.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                textFontPOOPINS(
                  //
                  TEXT_MANAGE_CARDS,
                  Colors.white,
                  18.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1E1E1E), // Darker color
                Color(0xFF3C3C3C), // Slightly lighter color
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(
              14.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.asset(
                    'assets/images/menu_send_money.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              textFontPOOPINS(
                //
                TEXT_SEND_MONEY,
                Colors.white,
                18.0,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        width: 20.0,
      ),
    ],
  );
}

Widget widgetDashbaordLowerDeck() {
  return Row(
    children: [
      const SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1E1E1E), // Darker color
                Color(0xFF3C3C3C), // Slightly lighter color
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(
              14.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.asset(
                    'assets/images/menu_wallet.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              textFontPOOPINS(
                //
                TEXT_WALLER,
                Colors.white,
                18.0,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1E1E1E), // Darker color
                Color(0xFF3C3C3C), // Slightly lighter color
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(
              14.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.asset(
                    'assets/images/menu_statement.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              textFontPOOPINS(
                //
                TEXT_STATEMENT,
                Colors.white,
                18.0,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        width: 20.0,
      ),
    ],
  );
}
