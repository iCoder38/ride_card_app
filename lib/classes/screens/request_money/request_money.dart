import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';

class RequestMoneyScreen extends StatefulWidget {
  const RequestMoneyScreen({super.key});

  @override
  State<RequestMoneyScreen> createState() => _RequestMoneyScreenState();
}

class _RequestMoneyScreenState extends State<RequestMoneyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
        child: _UIKitRequestMoneyAfterBG(context),
      ),
    );
  }

  Widget _UIKitRequestMoneyAfterBG(context) {
    return Column(
      children: [
        const SizedBox(
          height: 80.0,
        ),
        customNavigationBar(context, TEXT_NAVIGATION_TITLE_REQUEST_MONEY),
        /*Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                16.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: textFontPOOPINS(
                              '\nCurrent balance\n',
                              Colors.black,
                              16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: textFontPOOPINS(
                              '\$15,000',
                              Colors.black,
                              30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RequestMoneyScreen()),
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: hexToColor(appREDcolorHexCode),
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                          child: Center(
                            child: textFontPOOPINS(
                              'Request',
                              Colors.white,
                              16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ), 
              ],
            ),
          ),
        ),*/
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 24.0,
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
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
              ),
              title: textFontPOOPINS(
                'Dishant rajput',
                Colors.black,
                18.0,
              ),
              subtitle: textFontPOOPINS(
                '+91-8287632340',
                Colors.grey,
                12.0,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 60.0,
        ),
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(
              60.0,
            ),
          ),
          child: Image.asset('assets/images/payment.png'),
        ),
        const SizedBox(
          height: 60.0,
        ),
        textFontPOOPINS(
          //
          'Enter amount to request',
          appORANGEcolor,
          16.0,
          fontWeight: FontWeight.w600,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            child: Center(
              child: TextFormField(
                textAlign: TextAlign.center,
                // controller: _contPhone,
                decoration: const InputDecoration(
                  hintText: '\$0.0',
                  border: InputBorder.none, // Remove the border
                  filled: false,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 24.0,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return TEXT_FIELD_EMPTY_TEXT;
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const SuccessScreen()),
              // );
            },
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: hexToColor(appREDcolorHexCode),
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  child: Center(
                    child: textFontPOOPINS(
                      'Request money',
                      Colors.white,
                      22.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
