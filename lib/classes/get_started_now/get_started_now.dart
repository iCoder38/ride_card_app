import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/screens/select_profile/select_profile.dart';
import 'package:ride_card_app/classes/screens/welcome/welcome.dart';

class GetStartedNowScreen extends StatefulWidget {
  const GetStartedNowScreen({super.key});

  @override
  State<GetStartedNowScreen> createState() => _GetStartedNowScreenState();
}

class _GetStartedNowScreenState extends State<GetStartedNowScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
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
          PageView(
            controller: _pageController,
            children: [
              Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ],
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
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Text(
                    'Previous',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 3; i++)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == i ? Colors.red : Colors.grey,
                        ),
                      ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 16),
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
                      builder: (context) => const WelcomeScreen(),
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
          // Positioned(
          //   bottom: 30.0,
          //   left: 0,
          //   right: 0,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       for (int i = 0; i < 3; i++)
          //         Container(
          //           margin: const EdgeInsets.symmetric(horizontal: 5.0),
          //           width: 10.0,
          //           height: 10.0,
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: _currentPage == i
          //                 ? hexToColor(appORANGEcolorHexCode)
          //                 : Colors.grey,
          //           ),
          //         ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
