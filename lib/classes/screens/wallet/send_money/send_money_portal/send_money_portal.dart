import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/request_money/request_money.dart';
import 'package:ride_card_app/classes/screens/success/success.dart';
import 'package:ride_card_app/classes/screens/wallet/add_money/add_money.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';

class SendMoneyPortalScreen extends StatefulWidget {
  const SendMoneyPortalScreen({super.key, this.data});

  final data;
  @override
  State<SendMoneyPortalScreen> createState() => _SendMoneyPortalScreenState();
}

class _SendMoneyPortalScreenState extends State<SendMoneyPortalScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool screenLoader = true;
  var myFullData;
  var myCurrentBalance;
  //
  @override
  void initState() {
    if (kDebugMode) {
      print(widget.data);
    }
    //
    fetchProfileData();
    super.initState();
  }

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
    return screenLoader == true
        ? const SizedBox()
        : Column(
            children: [
              const SizedBox(
                height: 80.0,
              ),
              customNavigationBar(
                context,
                TEXT_NAVIGATION_TITLE_SEND_MONEY,
              ),
              Padding(
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
                                    // sd
                                    COUNTRY_CURRENCY + myCurrentBalance,
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
                                  builder: (context) => const AddMoneyScreen()),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Center(
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: hexToColor(appREDcolorHexCode),
                                  borderRadius: BorderRadius.circular(
                                    16.0,
                                  ),
                                ),
                                child: Center(
                                  child: textFontPOOPINS(
                                    'Add money',
                                    Colors.white,
                                    14.0,
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
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
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
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          40.0,
                        ),
                        child: Image.network(
                          // sd
                          widget.data['profile_picture'],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    title: textFontPOOPINS(
                      // sd
                      widget.data['userName'],
                      Colors.black,
                      18.0,
                    ),
                    subtitle: textFontPOOPINS(
                      // sd
                      widget.data['usercontactNumber'],
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
                'Enter amount to send',
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
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SuccessScreen()),
                    );*/
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
                            'Send money',
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

  // EVS: API => GET USER PROFILE DATA
  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) {
      myFullData = v;

      debugPrint(myFullData['data']['wallet'].toString());
      // current wallet balance
      if (myFullData['data']['wallet'].toString() == '') {
        myCurrentBalance = '0';
      } else {
        myCurrentBalance = myFullData['data']['wallet'].toString();
      }

      setState(() {
        screenLoader = false;
      });
    });
    // print(responseBody);
  }
}
