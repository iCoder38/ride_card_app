import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ride_card_app/classes/common/hive/hive.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';
import 'package:ride_card_app/classes/screens/splash/splash.dart';
import 'firebase_options.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_idensic_mobile_sdk_plugin/flutter_idensic_mobile_sdk_plugin.dart';

RemoteMessage? initialMessage;

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  //

  // debugPrint('Starting to load .env');
  try {
    await dotenv.load(fileName: ".env");
    // debugPrint('.env loaded successfully');
  } catch (e) {
    // debugPrint('Failed to load .env: $e');
  }

  // init stripe
  initializeStripe();

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

void initializeStripe() {
  Stripe.publishableKey = dotenv.env['STRIPE_PK_KEY']!;
}
