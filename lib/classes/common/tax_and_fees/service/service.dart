// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ride_card_app/classes/common/alerts/alert.dart';
// import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
// import 'package:ride_card_app/classes/common/methods/methods.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> chargeMoney({
//   required BuildContext context,
//   required double amount,
//   required String token,
//   required Future<String> Function() getCardSavedStatus,
//   required String userIdKey,
//   required String userRoleKey,
//   required String feesAndTaxesType,
//   required Future<StripeResponse?> Function({
//     required double amount,
//     required String stripeCardToken,
//     required String type,
//   }) chargeStripe,
//   required Future<void> Function() createUnitBankAccount,
//   required Future<String> Function(String userId, String email, String role)
//       generateToken,
// }) async {
//   debugPrint('API: Charge amount: Send stripe data to server.');
//   showLoadingUI(context, 'Please wait...');

//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var userId = prefs.getString(userIdKey).toString();
//   var roleIs = prefs.getString(userRoleKey).toString();

//   if (kDebugMode) {
//     print('===================================');
//     print('CONVENIENCE FEES IS: ====> $amount');
//     print('===================================');
//   }

//   final response = await chargeStripe(
//     amount: amount,
//     stripeCardToken: token,
//     type: feesAndTaxesType,
//   );

//   if (kDebugMode && response != null) {
//     if (kDebugMode) {
//       print(response.message);
//     }
//   }

//   if (response != null) {
//     if (response.status == 'Fail') {
//       debugPrint('API: FAILS.');
//       Navigator.pop(context);
//       customToast(
//         response.message,
//         Colors.redAccent,
//         ToastGravity.BOTTOM,
//       );
//     } else if (response.status == 'NOT_AUTHORIZED') {
//       debugPrint('CHARGE AMOUNT API IS NOT AUTHORIZED. PLEASE AUTHORIZE');
//       generateToken(userId, loginUserEmail(), roleIs).then((v) {
//         if (kDebugMode) {
//           print('TOKEN ==> $v');
//         }
//         // Retry charging
//         chargeMoney(
//           context: context,
//           amount: amount,
//           token: token,
//           getCardSavedStatus: getCardSavedStatus,
//           userIdKey: userIdKey,
//           userRoleKey: userRoleKey,
//           feesAndTaxesType: feesAndTaxesType,
//           chargeStripe: chargeStripe,
//           createUnitBankAccount: createUnitBankAccount,
//           generateToken: generateToken,
//         );
//       });
//       return;
//     } else {
//       debugPrint(
//           'Success: Payment deducted from stripe. Now create UNIT bank account');
//       await createUnitBankAccount();
//     }
//   } else {
//     Navigator.pop(context);
//   }
// }
