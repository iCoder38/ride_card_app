import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, String>> fetchCardDetails({
  required String customerToken,
  required String cardId,
}) async {
  final headers = {
    'Authorization': 'Bearer $customerToken',
  };

  // Replace with the actual base URL
  const baseUrl =
      'https://js.verygoodvault.com/vgs-show/1.5/ACh8JJTM42LYxwe2wfGQxwj5.js';

  try {
    // Fetch the CVV2
    final cvv2Response = await http.get(
      Uri.parse('$baseUrl/cards/$cardId/secure-data/cvv2'),
      headers: headers,
    );

    if (cvv2Response.statusCode == 200) {
      final cvv2Json = jsonDecode(cvv2Response.body);
      String cvv2 = cvv2Json['data']['attributes']['cvv2'];

      // Fetch the card number (PAN)
      final cardNumberResponse = await http.get(
        Uri.parse('$baseUrl/cards/$cardId/secure-data/pan'),
        headers: headers,
      );

      if (cardNumberResponse.statusCode == 200) {
        final cardNumberJson = jsonDecode(cardNumberResponse.body);
        String cardNumber = cardNumberJson['data']['attributes']['pan'];

        // Return the card details as a Map
        return {
          'cardNumber': cardNumber,
          'cvv2': cvv2,
        };
      } else {
        print(
            'Failed to fetch card number. Status code: ${cardNumberResponse.statusCode}');
        return {};
      }
    } else {
      print('Failed to fetch CVV2. Status code: ${cvv2Response.statusCode}');
      return {};
    }
  } catch (e) {
    print('Error occurred: $e');
    return {};
  }
}
