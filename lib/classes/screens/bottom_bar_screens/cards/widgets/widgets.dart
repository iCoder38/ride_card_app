import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/screens/all_cards/all_cards.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}

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
              checkCreditScore();
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
                      'assets/images/cards3.png',
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
                    'assets/images/send-money.png',
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
                    'assets/images/cards1.png',
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
                    'assets/images/statement.png',
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
