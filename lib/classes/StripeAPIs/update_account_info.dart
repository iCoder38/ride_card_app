// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;

// Future<bool> updateAccountInformation(String connectedAccountId, String apiKey,
//     {required String businessUrl, required String statementDescriptor}) async {
//   final url =
//       Uri.parse('https://api.stripe.com/v1/accounts/$connectedAccountId');
//   final response = await http.post(
//     url,
//     headers: {
//       'Authorization': 'Bearer $apiKey',
//       'Content-Type': 'application/x-www-form-urlencoded',
//     },
//     body: {
//       // 'business_profile[url]': businessUrl,
//       'settings[payments][statement_descriptor]': statementDescriptor,
//     },
//   );

//   if (response.statusCode == 200) {
//     if (kDebugMode) {
//       print('Account information updated successfully.');
//     }
//     return true;
//   } else {
//     print('Failed to update account information: ${response.body}');
//     return false;
//   }
// }
