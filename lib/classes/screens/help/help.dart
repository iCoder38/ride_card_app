import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/help/service/service.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  var helpData;
  bool screenLoader = true;
  //
  @override
  void initState() {
    //
    fetchHelp();
    super.initState();
  }

  Future<void> fetchHelp() async {
    await helpApi().then((v) {
      helpData = v;
    });
    setState(() {
      screenLoader = false;
    });
    // print(responseBody);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: _UIKit(context),
    );
  }

  Widget _UIKit(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.amber,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover, // Ensure the image covers the whole container
        ),
      ),
      child: _UIKitStackBG(context),
    );
  }

  Widget _UIKitStackBG(BuildContext context) {
    return screenLoader == true
        ? const SizedBox()
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: Column(
                children: [
                  //
                  const SizedBox(
                    height: 80.0,
                  ),
                  customNavigationBarForMenu('Help', _scaffoldKey),
                  //
                  Container(
                    margin: const EdgeInsets.only(top: 40.0),
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        24.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: Container(
                      height: 140,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textFontPOOPINS(
                            'CONNECT WITH US',
                            hexToColor(appORANGEcolorHexCode),
                            18.0,
                            fontWeight: FontWeight.w800,
                          ),
                          const SizedBox(height: 8.0),
                          textFontPOOPINS(
                            'Whatsapp: ',
                            Colors.white,
                            14.0,
                          ),
                          const SizedBox(height: 4.0),
                          textFontPOOPINS(
                            'Support number: ',
                            Colors.white,
                            14.0,
                          ),
                          const SizedBox(height: 4.0),
                          textFontPOOPINS(
                            'Email: support@',
                            Colors.white,
                            14.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 80.0),
                  textFontPOOPINS(
                    '© Copyright 2024 Ride Card App. All Rights Reserved.',
                    Colors.white,
                    12.0,
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          );
  }
}
