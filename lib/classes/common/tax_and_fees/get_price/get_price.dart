import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_card_app/classes/common/tax_and_fees/get_price/model/model.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';

class ApiServiceToGetFeesAndTaxes {
  static String baseUrl = BASE_URL;

  Future<List<FeeData>?> fetchFeesAndTaxes() async {
    try {
      final parameters = {'action': 'admincharge'};

      final response = await http.post(
        Uri.parse('$baseUrl/fees'),
        body: jsonEncode(parameters),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          List<dynamic> data = jsonResponse['data'];
          List<FeeData> feeDataList =
              data.map((item) => FeeData.fromJson(item)).toList();
          return feeDataList;
        } else {
          if (kDebugMode) {
            print('Failed to fetch fees: ${jsonResponse['status']}');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during the POST request: $error');
      }
      return null;
    }
  }
}
