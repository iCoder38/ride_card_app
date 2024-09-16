import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:uuid/uuid.dart';

class CheckUnitWalletStatus {
  /*Future<http.Response> getWalletAccount(
    String accountId,
  ) async {
    // final url = Uri.parse('https://api.s.unit.sh/accounts/$accountId');
    final url = Uri.parse('https://api.s.unit.sh/accounts/1003796354');
    final headers = {
      'Authorization': 'Bearer $TESTING_TOKEN',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Successful response
      return response;
    } else {
      // Handle error
      throw Exception('Failed to fetch wallet account: ${response.statusCode}');
    }
  }*/
  Future<http.Response> checkWalletStatus(
    String customerId,
  ) async {
    final url = Uri.parse('https://api.s.unit.sh/accounts');
    final headers = {
      'Content-Type': 'application/vnd.api+json',
      'Authorization': 'Bearer $TESTING_TOKEN',
    };
    final body = jsonEncode({
      "data": {
        "type": "walletAccount",
        "attributes": {
          "walletTerms": "walletDefault",
          "tags": {"purpose": "Healthcare"},
          "idempotencyKey": const Uuid().v4(),
        },
        "relationships": {
          "customer": {
            "data": {
              "type": "customer",
              "id": customerId,
            },
          },
        },
      },
    });
    logger.d(body);
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Successful response
      return response;
    } else {
      // Handle error
      throw Exception('Failed to create wallet account: ${response.body}');
    }
  }
}
