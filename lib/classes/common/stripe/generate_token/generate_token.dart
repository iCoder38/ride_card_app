// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:ride_card_app/classes/common/methods/methods.dart';

// Future<String?> generateStripeTokenService({
//   required BuildContext context,
//   required String cardNumber,
//   required String expMonth,
//   required String expYear,
//   required String cvv,
//   required double amount,
//   // required Function() showLoading,
//   // required Function() hideLoading,
//   required Function(String message) onError,
//   required Function(String token) onSuccess,
// }) async {
//   try {
//     // Prepare card details
//     CardTokenParams cardParams = CardTokenParams(
//       type: TokenType.Card,
//       name: loginUserName(),
//     );

//     await Stripe.instance.dangerouslyUpdateCardDetails(
//       CardDetails(
//         number: cardNumber,
//         cvc: cvv,
//         expirationMonth: int.tryParse(expMonth),
//         expirationYear: int.tryParse(expYear),
//       ),
//     );

//     // Log the details for debugging
//     // if (kDebugMode) {
//     //   print('amount: $amount');
//     //   print('card number: $cardNumber');
//     //   print('cvv: $cvv');
//     //   print('exp month: $expMonth');
//     //   print('exp year: $expYear');
//     // }

//     // Generate token
//     TokenData token = await Stripe.instance.createToken(
//       CreateTokenParams.card(params: cardParams),
//     );

//     if (kDebugMode) {
//       print("Flutter Stripe token  ${token.toJson()}");
//       print(token.id.toString());
//     }

//     // if (isMounted) {
//     onSuccess(token.id.toString());
//     if (kDebugMode) {
//       print('called ??');
//     }
//     // }

//     // Return the token
//     return token.id;
//   } on StripeException catch (e) {
//     final bool isMounted = ModalRoute.of(context)?.isCurrent ?? false;
//     // Handle the error
//     if (kDebugMode) {
//       print("Flutter Stripe error ${e.error.message}");
//     }

//     // Hide loading UI
//     if (isMounted) {
//       // hideLoading();
//     }

//     // Show error message
//     onError(e.error.message ?? 'An error occurred');

//     return null;
//   } finally {
//     final bool isMounted = ModalRoute.of(context)?.isCurrent ?? false;
//     // Hide loading UI in case of any exception
//     if (isMounted) {
//       // hideLoading();
//     }
//   }
// }

import 'package:flutter/foundation.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';

Future<Map<String, dynamic>> createStripeToken({
  required String cardNumber,
  required String expMonth,
  required String expYear,
  required String cvc,
}) async {
  try {
    // Set up card details and parameters for the token
    CardTokenParams cardParams = CardTokenParams(
      type: TokenType.Card,
      name: loginUserName(),
    );

    await Stripe.instance.dangerouslyUpdateCardDetails(
      CardDetails(
        number: cardNumber,
        cvc: cvc,
        expirationMonth: int.tryParse(expMonth),
        expirationYear: int.tryParse(expYear),
      ),
    );

    // Create a token
    final token = await Stripe.instance.createToken(
      CreateTokenParams.card(params: cardParams),
    );

    /*customToast(
      'Token: $token',
      Colors.red,
      ToastGravity.BOTTOM,
    );*/

    if (kDebugMode) {
      print('Token created: ${token.id}');
    }
    /*customToast(
      'TokenId: ${token.id.toString()}',
      Colors.red,
      ToastGravity.BOTTOM,
    );*/

    // Return success with the token ID
    return {
      'success': true,
      'tokenId': token.id,
    };
  } on StripeException catch (e) {
    // Handle the error by returning a message
    if (kDebugMode) {
      print('Error creating token: ${e.error.message}');
    }
    return {
      'success': false,
      'message':
          e.error.message ?? 'An error occurred while creating the token.',
    };
  }
}
