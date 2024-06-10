import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/all_cards/service/service.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/send_money.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  //
  bool screenLoader = true;
  var myFullData;
  var myCurrentBalance;
  final apiService = ApiServiceForListOfAllCards();
  List<dynamic> cards = [];
  //
  @override
  void initState() {
    //
    fetchProfileData();
    super.initState();
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
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _UIKitAddMoneyAfterBG(context),
      ),
    );
  }

  Widget _UIKitAddMoneyAfterBG(context) {
    return screenLoader == true
        ? const SizedBox()
        : Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              customNavigationBar(context, TEXT_NAVIGATION_TITLE_ADD_MONEY),
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
                                    // sv
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
                            setState(() {
                              debugPrint('object');
                              Navigator.pop(context);
                            });
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
                                    'Send',
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
              ),
              ListTile(
                title: textFontPOOPINS(
                  TEXT_SELECT_AMOUNT,
                  hexToColor(appORANGEcolorHexCode),
                  16.0,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: textFontPOOPINS(
                  TEXT_SELECT_AMOUNT_SUB_TITLE,
                  Colors.white,
                  12.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    'assets/images/dollar@2x.png',
                                  ),
                                ),
                              ),
                              textFontPOOPINS(
                                '\$100',
                                Colors.black,
                                26.0,
                                fontWeight: FontWeight.w800,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    'assets/images/dollar@2x.png',
                                  ),
                                ),
                              ),
                              textFontPOOPINS(
                                '\$500',
                                Colors.black,
                                26.0,
                                fontWeight: FontWeight.w800,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    'assets/images/dollar@2x.png',
                                  ),
                                ),
                              ),
                              textFontPOOPINS(
                                'Custom',
                                Colors.black,
                                20.0,
                                fontWeight: FontWeight.w800,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                title: textFontPOOPINS(
                  //
                  TEXT_SELECT_CARD_TITLE,
                  hexToColor(appORANGEcolorHexCode),
                  16.0,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: textFontPOOPINS(
                  //
                  TEXT_SELECT_CARD_SUB_TITLE,
                  Colors.white,
                  12.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    for (int i = 0; i < cards.length; i++) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: textFontPOOPINS(
                            // sv
                            cards[i]['cardNumber'],
                            Colors.black,
                            18.0,
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: textFontPOOPINS(
                            // sv
                            cards[i]['Expiry_Month'] +
                                '/' +
                                cards[i]['Expiry_Year'],
                            Colors.black,
                            12.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                    ]
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: hexToColor(appREDcolorHexCode),
                    borderRadius: BorderRadius.circular(
                      14.0,
                    ),
                  ),
                  child: Center(
                    child: textFontPOOPINS(
                      //
                      TEXT_PROCCED,
                      Colors.white,
                      18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            ],
          );
  }

  void fetchCards() async {
    debugPrint('FETCH ALL CARDS');
    List<dynamic> fetchedCards = await apiService.listOfAllCards(context);
    setState(() {
      cards = fetchedCards;
      screenLoader = false;
    });
  }

  // EVS: API => GET USER PROFILE DATA
  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) {
      myFullData = v;

      // debugPrint(myFullData['data']['wallet'].toString());
      // current wallet balance
      if (myFullData['data']['wallet'].toString() == '') {
        myCurrentBalance = '0';
      } else {
        myCurrentBalance = myFullData['data']['wallet'].toString();
      }
      //
      debugPrint('2222');
      fetchCards();
    });
    // print(responseBody);
  }
}
