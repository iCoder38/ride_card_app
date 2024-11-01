import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';

Future<dynamic> fetchCreditScore2({
  required String apiUrl,
  required String clientId,
  required String clientSecret,
  required String moduleSecret,
  required String providerSecret,
  required String name,
  required String mobile,
  required String inquiryPurpose,
  required String documentType,
  required String documentId,
}) async {
  try {
    // Construct the request headers with your client ID
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'client_id': clientId,
      'client_secret': clientSecret,
      'module_secret': moduleSecret,
      'provider_secret': providerSecret,
    };

    // Generate a random string
    String randomString = generateRandomString(10);

    // Construct the request body with the necessary parameters
    Map<String, dynamic> requestBody = {
      "reference_id": 'RCA_$randomString',
      "consent": true,
      "consent_purpose": "for bank verification only",
      "name": name,
      "mobile": mobile,
      "inquiry_purpose": inquiryPurpose,
      "document_type": documentType,
      "document_id": documentId,
    };
    if (kDebugMode) {
      print(requestBody);
    }

    // Convert the request body to JSON
    String requestBodyJson = json.encode(requestBody);
    // logger.d(requestBodyJson);

    // Convert the API URL string to a Uri object
    Uri uri = Uri.parse(
        'https://in.staging.decentro.tech/v2/financial_services/credit_bureau/credit_report/summary');
    // logger.d(uri);

    http.Response response =
        await http.post(uri, headers: headers, body: requestBodyJson);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      // print(data);

      return data;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    }
  } catch (error) {
    // Handle network errors or exceptions
    if (kDebugMode) {
      print('Error: $error');
    }
    return 'Error: $error';
  }
}
