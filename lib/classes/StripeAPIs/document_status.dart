import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<String?> checkDocumentStatus(String accountId, String apiKey) async {
  final url = Uri.parse('https://api.stripe.com/v1/accounts/$accountId');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);

    // Check if there are any missing verification requirements
    List<dynamic>? missingRequirements =
        responseData['requirements']?['currently_due'];

    if (missingRequirements != null && missingRequirements.isNotEmpty) {
      // Print each requirement that is currently due
      if (kDebugMode) {
        print("Currently due requirements:");
      }
      for (var requirement in missingRequirements) {
        print("- $requirement");
      }

      // Check document verification status if available
      String? documentStatus =
          responseData['individual']?['verification']?['document']?['status'];

      if (documentStatus != null) {
        if (documentStatus == 'pending') {
          return "Document is pending verification.";
        } else if (documentStatus == 'verified') {
          return "Document is verified.";
        } else if (documentStatus == 'review') {
          return "Document is in review status.";
        } else if (documentStatus == 'unverified') {
          return "Document verification failed.";
        } else {
          return "Unknown document status: $documentStatus";
        }
      } else {
        return "Document status not available, but requirements are pending. Please check requirements.";
      }
    } else {
      return "No verification requirements are currently due.";
    }
  } else {
    throw Exception('Failed to retrieve account details: ${response.body}');
  }
}
