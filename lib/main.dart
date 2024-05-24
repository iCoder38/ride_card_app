import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ride_card_app/classes/common/hive/hive.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';
import 'package:ride_card_app/classes/screens/splash/splash.dart';
import 'firebase_options.dart';

import 'package:hive_flutter/hive_flutter.dart';
// Import the generated adapter

RemoteMessage? initialMessage;

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  // HIVE
// Register Hive adapter
  // Register Hive adapter
  Hive.registerAdapter(MyDataAdapter());

  await Hive.initFlutter();

  await Firebase.initializeApp(
    // name: '',
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