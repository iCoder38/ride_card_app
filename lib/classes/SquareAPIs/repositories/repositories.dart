import 'package:flutter/foundation.dart';
import 'package:ride_card_app/classes/SquareAPIs/services/services.dart';

class SquareRepository {
  final SquareService _squareService = SquareService();

  Future<void> addCustomer({
    required String givenName,
    required String familyName,
    required String emailAddress,
    required String addressLine1,
    String? addressLine2,
    required String locality,
    required String adminDistrict,
    required String postalCode,
    required String country,
    required String phoneNumber,
    String? referenceId,
    String? note,
  }) async {
    final customerData = {
      "given_name": givenName,
      "family_name": familyName,
      "email_address": emailAddress,
      "address": {
        "address_line_1": addressLine1,
        "address_line_2": addressLine2 ?? "",
        "locality": locality,
        "administrative_district_level_1": adminDistrict,
        "postal_code": postalCode,
        "country": country
      },
      "phone_number": phoneNumber,
      "reference_id": referenceId ?? "",
      "note": note ?? "",
    };

    final response = await _squareService.createCustomer(customerData);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Customer created successfully');
      }
    } else {
      if (kDebugMode) {
        print('Failed to create customer: ${response.body}');
      }
    }
  }
}
