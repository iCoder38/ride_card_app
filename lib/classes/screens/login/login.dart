import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/screens/bottom_bar/bottom_bar.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';
import 'package:ride_card_app/classes/service/service/service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService _apiService = ApiService();
  @override
  void initState() {
    _sendToLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _UIKit(context),
    );
  }

  Widget _UIKit(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.amber,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover, // Ensure the image covers the whole container
        ),
      ),
      //  child: _UIKitStackBG(context),
    );
  }

  void _sendToLogin(context) async {
    debugPrint('API ==> LOGIN');

    final parameters = {
      'action': 'login',
      'email': 'dishantrajput2021@gmail.com',
      'password': '123456',
    };
    if (kDebugMode) {
      print(parameters);
    }
    // return;
    try {
      final response = await _apiService.postRequest(parameters, '');
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');
        //
        _loginViaFirebase();
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  Future<void> _loginViaFirebase() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: 'dishantrajput2021@gmail.com',
              password: 'firebase_password_rca_!')
          .then((v) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomBar(selectedIndex: 0),
          ),
        );
      });
    } catch (e) {
      print(e); // Handle errors here
    }
  }
}
