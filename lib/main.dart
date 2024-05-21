import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';
import 'package:ride_card_app/classes/screens/splash/splash.dart';
import 'firebase_options.dart';

RemoteMessage? initialMessage;

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // name: 'Crazy Anamak 2',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      //
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      initialRoute: '/',
      routes: {
        '/dashboard': (context) => const CardsScreen(),
      },
    ),
  );

  // runApp(const MyApp());
}
// 47015978