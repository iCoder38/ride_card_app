// ignore_for_file: prefer_final_fields, unused_field, non_constant_identifier_names

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/screens/welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  RemoteMessage? initialMessage;
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //
  FirebaseAuth firebase_auth = FirebaseAuth.instance;
  //
  late Timer _timer;
  int _start = 2;
  //
  late Timer loginTimer;
  int loginTimerCount = 4;
  //
  String? notifTitle, notifBody;
  //
  var strDoneWithOnboarding = '0';
  //
  @override
  void initState() {
    if (kDebugMode) {
      print('I AM IN SPLASH SCREEN');
    }
    // signOut();
    // #1
    clearCache();
    //
    checkNotificationPermission();
    super.initState();
  }

  checkNotificationPermission() async {
    //
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (kDebugMode) {
      print('User granted permission =====> ${settings.authorizationStatus}');
    }
    // to get device token
    fetchDeviceToken();
  }

  fetchDeviceToken() {
    FirebaseMessaging firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    firebaseMessaging.getToken().then((token) {
      if (kDebugMode) {
        print("token is $token");
      }
    });
    //
    foregorundHandler();
  }

  foregorundHandler() async {
    //
    if (kDebugMode) {
      print('==== FOREGROUND ACCESS ====');
      print('YES');
      print('===========================');
    }
    // foreground access
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    //
    bacgroundNotificationHandler();
  }

  bacgroundNotificationHandler() {
    //
    if (kDebugMode) {
      print('==== BACKGROUND ACCESS ====');
      print('YES');
      print('===========================');
    }
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    //
    // check onboarding
    checkOnboarding();
  }

  // BACKGROUND HANDLER
  Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
    }
  }

  checkOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('onboarding_screen_see') == 'yes') {
      strDoneWithOnboarding = '1';
    } else {
      strDoneWithOnboarding = '0';
    }
    // timer for splash
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: textFontOPENSANS(
          'Ride Card App',
          Colors.black,
          16.0,
        ),
      ),
    );
  }

// get notification in foreground
  func_get_full_data_of_notification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      /*if (kDebugMode) {
        print('============================================');
        print('=====> GOT NOTIFICATION IN FOREGROUND <=====');
        print('============================================');
      }*/
      /*if (kDebugMode) {
        print('Message data: ${message.data}');
      }*/
      if (message.notification != null) {
        /*if (kDebugMode) {
          print('=================================================');
          print('Foreground Notification: ${message.notification}');
          print('=================================================');
        }*/
        setState(() {
          notifTitle = message.notification!.title;
          notifBody = message.notification!.body;
        });
      }
    });
  }

  func_click_on_notification() {
// FirebaseMessaging.configure

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      if (kDebugMode) {
        print('=====> CLICK NOTIFICATIONs <=====');
        print(remoteMessage.data);
      }
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => const HomeFeedScreen(),
              builder: (context) => const WelcomeScreen(),
            ),
          );
          /*(strDoneWithOnboarding == '1')
              ? checkUserIsLoginOrNot(context, '1')
              : checkUserIsLoginOrNot(context, '2');*/
        } else {
          setState(
            () {
              if (kDebugMode) {
                print('Timer ==> $_start');
              }
              _start--;
            },
          );
        }
      },
    );
  }
}

checkUserIsLoginOrNot(context, status) {
  //
  if (kDebugMode) {
    print(status);
  }
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      if (kDebugMode) {
        print('User is currently signed out!');
      }
      /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );*/
    } else {
      if (kDebugMode) {
        print('User is signed in!');
        print(FirebaseAuth.instance.currentUser!.uid);
      }
      /*if (status == '1') {
        if (FirebaseAuth.instance.currentUser!.emailVerified == false) {
          // signOut(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => const HomeFeedScreen(),
              builder: (context) => const LoginScreen(),
            ),
          );
        } else {
          checkUserIsAlreadyInDB(context);
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      }*/
    }
  });
}

/*checkUserIsAlreadyInDB(context) {
  //
  if (kDebugMode) {
    debugPrint('CHECKING USER IS NEW OR NOT');
    debugPrint(FirebaseAuth.instance.currentUser!.uid);
  }
  checkUserIsAlreadyInDBfb(FirebaseAuth.instance.currentUser!.uid)
      .then((loginUserData) {
    if (loginUserData.length == 0) {
      if (kDebugMode) {
        print('========================================');
        print('NO, USER IS NOT AVAILABLE in FIREBASE DB normal');
        print('========================================');
      }
      //
      // saveLoginUserDataInFirebase('', context);
    } else {
      if (kDebugMode) {
        print(loginUserData.first['active']);
      }
      if (loginUserData.first['active'] == 'no') {
        //
        your_account_is_not_active(context).then((v) {
          debugPrint('===============');
          debugPrint('NOT ACTIVE USER');
          debugPrint('===============');
          signOut(context);
        });
      } else {
        //
        Navigator.push(
          context,
          MaterialPageRoute(
            // builder: (context) => const HomeFeedScreen(),
            builder: (context) => const BottomBarScreen(),
          ),
        );
      }
    }
  });
}*/

// wesqod-9hyrtE-mekcaw

