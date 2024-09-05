import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/headers/unit/unit_utils.dart';
import 'package:uuid/uuid.dart';

// //
// class IssueCardService {
//   static Future<bool> issueCard(String bankAccountId) async {
//     debugPrint('========== ISSUE CARD URL ================');
//     final url = Uri.parse(ISSUE_CARD_URL);
//     if (kDebugMode) {
//       print(url);
//     }
//     debugPrint('==========================================');

//     // Define custom headers
//     Map<String, String> headers = {
//       'Content-Type': 'application/vnd.api+json',
//       'Authorization': 'Bearer $TESTING_TOKEN',
//     };

//     // Define the request body
//     Map<String, dynamic> requestBody = {
//       "data": {
//         "type": CARD_INDIVIDUAL_V_D_C_TYPE,
//         "attributes": {
//           "idempotencyKey": const Uuid().v4(),
//           "limits": {
//             "dailyWithdrawal": CARD_I_V_D_C_DAILY_WITHDRAWAL,
//             "dailyPurchase": CARD_I_V_D_C_DAILY_PURCHASE,
//             "monthlyWithdrawal": CARD_I_V_D_C_MONTHLY_WITHDRAWAL,
//             "monthlyPurchase": CARD_I_V_D_C_MONTHLY_PURCHASE
//           }
//         },
//         "relationships": {
//           "account": {
//             "data": {
//               "type": "depositAccount",
//               "id": bankAccountId,
//             }
//           }
//         }
//       }
//     };

//     try {
//       final response = await http.post(
//         url,
//         headers: headers,
//         body: jsonEncode(requestBody),
//       );
//       if (kDebugMode) {
//         print(response.statusCode);
//       }
//       if (response.statusCode == 201) {
//         // If the server returns a 201 Created response
//         if (kDebugMode) {
//           debugPrint('========== CARD ISSUED RESPONSE ================');
//           print(json.decode(response.body));
//           debugPrint('===================================================');
//         }
//         return true;
//       } else {
//         if (kDebugMode) {
//           final jsonData = json.decode(response.body);
//           print('Error creating account: $jsonData');
//         }
//         return false;
//       }
//     } catch (error) {
//       // Handle any errors that occur during the HTTP request
//       print('Error: $error');
//       return false;
//     }
//   }
// }

class IssueCardService {
  static Future<Map<String, dynamic>?> issueCard(
    String bankAccountId,
  ) async {
    debugPrint('========== ISSUE CARD URL ================');
    final url = Uri.parse(ISSUE_CARD_URL);
    if (kDebugMode) {
      print(url);
    }
    debugPrint('==========================================');

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    // Define the request body
    Map<String, dynamic> requestBody = {
      "data": {
        "type": CARD_INDIVIDUAL_V_D_C_TYPE,
        "attributes": {
          "idempotencyKey": const Uuid().v4(),
          "limits": {
            "dailyWithdrawal": CARD_I_V_D_C_DAILY_WITHDRAWAL,
            "dailyPurchase": CARD_I_V_D_C_DAILY_PURCHASE,
            "monthlyWithdrawal": CARD_I_V_D_C_MONTHLY_WITHDRAWAL,
            "monthlyPurchase": CARD_I_V_D_C_MONTHLY_PURCHASE
          }
        },
        "relationships": {
          "account": {
            "data": {
              "type": "depositAccount",
              "id": bankAccountId,
            }
          }
        }
      }
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 201) {
        // If the server returns a 201 Created response
        if (kDebugMode) {
          debugPrint('========== CARD ISSUED RESPONSE ================');
          print(json.decode(response.body));
          debugPrint('===================================================');
        }
        return json.decode(response.body);
      } else {
        if (kDebugMode) {
          final jsonData = json.decode(response.body);
          print('Error creating account: $jsonData');
        }
        return json.decode(response.body);
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
      return null;
    }
  }

  static Future<Map<String, dynamic>?> issueCardForIndividualDebitCard(
    String bankAccountId,
    String firstName,
    String lastName,
    String dob,
    String email,
    String phoneNumber,
    String street,
    String city,
    String state,
    String postalCode,
    String country,
  ) async {
    debugPrint('========== ISSUE PHYSICAL CARD URL ================');
    final url = Uri.parse(ISSUE_CARD_URL);
    if (kDebugMode) {
      print(url);
    }
    debugPrint('==========================================');

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    // Define the request body
    Map<String, dynamic> requestBody = {
      "data": {
        "type": 'individualDebitCard',
        "attributes": {
          "idempotencyKey": const Uuid().v4(),
          "limits": {
            "dailyWithdrawal": 50000,
            "dailyPurchase": 50000,
            "monthlyWithdrawal": 500000,
            "monthlyPurchase": 700000
          },
          "shippingAddress": {
            "street": street,
            "street2": null,
            "city": city,
            "state": state,
            "postalCode": postalCode,
            "country": country
          },
        },
        "relationships": {
          "account": {
            "data": {
              "type": "depositAccount",
              "id": bankAccountId,
            }
          }
        }
      }
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 201) {
        // If the server returns a 201 Created response
        if (kDebugMode) {
          debugPrint('========== CARD ISSUED RESPONSE ================');
          print(json.decode(response.body));
          debugPrint('===================================================');
        }
        return json.decode(response.body);
      } else {
        if (kDebugMode) {
          final jsonData = json.decode(response.body);
          print('Error creating account: $jsonData');
        }
        return json.decode(response.body);
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
      return null;
    }
  }
}

class IssueBusinessCardService {
  static Future<Map<String, dynamic>?> issueBusinessCard(
    String bankAccountId,
    String firstName,
    String lastName,
    String dob,
    String email,
    String phoneNumber,
    String street,
    String city,
    String state,
    String postalCode,
    String country,
  ) async {
    debugPrint('========== ISSUE BUSINESS CARD URL ================');
    final url = Uri.parse(ISSUE_CARD_URL);
    if (kDebugMode) {
      print(url);
    }
    debugPrint('==========================================');

    // Define custom headers
    Map<String, String> headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    // Define the request body
    Map<String, dynamic> requestBody = {
      "data": {
        "type": CARD_BUSINESS_VIRTUAL_DEBIT_CARD_UNIT,
        "attributes": {
          "idempotencyKey": const Uuid().v4(),
          "limits": {
            "dailyWithdrawal": 50000,
            "dailyPurchase": 50000,
            "monthlyWithdrawal": 500000,
            "monthlyPurchase": 700000
          },
          "fullName": {
            "first": firstName,
            "last": lastName,
          },
          "dateOfBirth": dob,
          "email": email,
          "phone": {
            "countryCode": "1",
            "number": phoneNumber,
          },
          "address": {
            "street": street,
            "street2": null,
            "city": city,
            "state": state,
            "postalCode": postalCode,
            "country": country
          },
        },
        "relationships": {
          "account": {
            "data": {
              "type": "depositAccount",
              "id": bankAccountId,
            }
          }
        }
      }
    };
    if (kDebugMode) {
      print(requestBody);
    }

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 201) {
        // If the server returns a 201 Created response
        if (kDebugMode) {
          debugPrint('========== CARD ISSUED RESPONSE ================');
          print(json.decode(response.body));
          debugPrint('===================================================');
        }
        return json.decode(response.body);
      } else {
        if (kDebugMode) {
          final jsonData = json.decode(response.body);
          print('Error creating BUSINESS CARD: $jsonData');
        }
        return json.decode(response.body);
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      if (kDebugMode) {
        print('Error: $error');
      }
      return null;
    }
  }
}
