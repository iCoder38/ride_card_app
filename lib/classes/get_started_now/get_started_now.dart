import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/screens/select_profile/select_profile.dart';

class GetStartedNowScreen extends StatefulWidget {
  const GetStartedNowScreen({super.key});

  @override
  State<GetStartedNowScreen> createState() => _GetStartedNowScreenState();
}

class _GetStartedNowScreenState extends State<GetStartedNowScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final List<String> _texts = [
    'Welcome to Ride Wallet',
    'Card management: Your money deserve the best. Free debit earn cashback',
    'Payment using wallet: Making digital transaction easy. Earn rewards daily'
  ];
  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          PageView(
            controller: _pageController,
            children: [
              Image.asset(
                'assets/images/3.png',
                fit: BoxFit.fitWidth,
              ),
              Image.asset(
                'assets/images/2.png',
                fit: BoxFit.fitWidth,
              ),
              Image.asset(
                'assets/images/1.png',
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
          // const SizedBox(height: 40),
          Positioned(
            bottom: 140.0,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _texts.length; i++)
                  if (_currentPage == i) ...[
                    if (i == 0) ...[
                      textFontPOOPINS(
                        _texts[i],
                        hexToColor(appORANGEcolorHexCode),
                        22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ] else if (i == 1) ...[
                      Column(
                        children: [
                          textFontPOOPINS(
                            'Card management',
                            hexToColor(appORANGEcolorHexCode),
                            22.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textFontPOOPINS(
                            'Your money deserve the best.',
                            Colors.white,
                            14.0,
                            fontWeight: FontWeight.w400,
                          ),
                          textFontPOOPINS(
                            'Free debit earn cashback.',
                            Colors.white,
                            12.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ] else if (i == 2) ...[
                      Column(
                        children: [
                          textFontPOOPINS(
                            'Payment using wallet.',
                            hexToColor(appORANGEcolorHexCode),
                            22.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textFontPOOPINS(
                            'Making digital transaction easy.',
                            Colors.white,
                            14.0,
                            fontWeight: FontWeight.w400,
                          ),
                          textFontPOOPINS(
                            'Earn rewards daily.',
                            Colors.white,
                            12.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                    // Expanded(
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: textFontPOOPINS(
                    //       _texts[i],
                    //       Colors.white,
                    //       14.0,
                    //     ),
                    //   ),
                    // ),
                  ]
              ],
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: textFontPOOPINS(
                    'Previous',
                    Colors.white,
                    14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 3; i++)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == i
                              ? hexToColor(appORANGEcolorHexCode)
                              : Colors.grey,
                        ),
                      ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: textFontPOOPINS(
                    'Next',
                    Colors.white,
                    14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40.0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: GestureDetector(
                onTap: () {
                  //
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (context) => const HomeFeedScreen(),
                      builder: (context) => const SelectProfileScreen(
                        strProfileSelect: '1',
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.red, width: 3.0),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: textFontPOOPINS(
                      'GET STARTED NOW',
                      Colors.white,
                      20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
