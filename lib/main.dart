import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ride_card_app/classes/common/hive/hive.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';
import 'package:ride_card_app/classes/screens/splash/splash.dart';
import 'firebase_options.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

RemoteMessage? initialMessage;

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  //
  Stripe.publishableKey =
      'pk_test_51POkgbCc4YwUErYBvQc176lx095ArTfNS4U5xhIKaAcAhK1SsvURDV3KUXEnTLFqOn4O6slM4v2BLZwshUZTCu7f00ga5PNA2O';
  //
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
/*
v2.public.eyJyb2xlIjoiYWRtaW4iLCJ1c2VySWQiOiI3NTY3Iiwic3ViIjoianVzdGluYmVubmV0dEByaWRlYXBwaW5jZ2xvYmFsLmNvbSIsImV4cCI6IjIwMjQtMDgtMjZUMTI6NDM6NTguNzA1WiIsImp0aSI6IjMzMDY2NSIsIm9yZ0lkIjoiNDIxOSIsInNjb3BlIjoiYXBwbGljYXRpb25zIGFwcGxpY2F0aW9ucy13cml0ZSBjdXN0b21lcnMgY3VzdG9tZXJzLXdyaXRlIGN1c3RvbWVyLXRhZ3Mtd3JpdGUgY3VzdG9tZXItdG9rZW4td3JpdGUgYWNjb3VudHMgYWNjb3VudHMtd3JpdGUgY2FyZHMgY2FyZHMtd3JpdGUgY2FyZHMtc2Vuc2l0aXZlIHRyYW5zYWN0aW9ucyB0cmFuc2FjdGlvbnMtd3JpdGUgYXV0aG9yaXphdGlvbnMgc3RhdGVtZW50cyBwYXltZW50cyBwYXltZW50cy13cml0ZSBwYXltZW50cy13cml0ZS1jb3VudGVycGFydHkgcGF5bWVudHMtd3JpdGUtbGlua2VkLWFjY291bnQgYWNoLXBheW1lbnRzLXdyaXRlIHdpcmUtcGF5bWVudHMtd3JpdGUgcmVwYXltZW50cyByZXBheW1lbnRzLXdyaXRlIHBheW1lbnRzLXdyaXRlLWFjaC1kZWJpdCBjb3VudGVycGFydGllcyBiYXRjaC1yZWxlYXNlcyBiYXRjaC1yZWxlYXNlcy13cml0ZSBsaW5rZWQtYWNjb3VudHMgd2ViaG9va3Mgd2ViaG9va3Mtd3JpdGUgZXZlbnRzIGV2ZW50cy13cml0ZSBhdXRob3JpemF0aW9uLXJlcXVlc3RzIGF1dGhvcml6YXRpb24tcmVxdWVzdHMtd3JpdGUgY2FzaC1kZXBvc2l0cyBjYXNoLWRlcG9zaXRzLXdyaXRlIGNoZWNrLWRlcG9zaXRzIGNoZWNrLWRlcG9zaXRzLXdyaXRlIHJlY2VpdmVkLXBheW1lbnRzIHJlY2VpdmVkLXBheW1lbnRzLXdyaXRlIGRpc3B1dGVzIGNoYXJnZWJhY2tzIHJld2FyZHMgcmV3YXJkcy13cml0ZSBjaGVjay1wYXltZW50cyBjaGVjay1wYXltZW50cy13cml0ZSBjcmVkaXQtZGVjaXNpb25zIGxlbmRpbmctcHJvZ3JhbXMgY3JlZGl0LWFwcGxpY2F0aW9ucyBjcmVkaXQtYXBwbGljYXRpb25zLXdyaXRlIG1pZ3JhdGlvbnMgbWlncmF0aW9ucy13cml0ZSIsIm9yZyI6IlJpZGUgYXBwIGluYyIsInNvdXJjZUlwIjoiIiwidXNlclR5cGUiOiJvcmciLCJpc1VuaXRQaWxvdCI6ZmFsc2V9oPEe4b0t2NMYJM38ZXvYzwKpPxoQK1NbYAsnOSMI-Ut2I8YBF2gDkIaCoN7Ua6LO8WVauqrCD_LhXoRqJeqIBw
*/