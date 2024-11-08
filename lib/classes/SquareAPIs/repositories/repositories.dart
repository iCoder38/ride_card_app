import 'package:flutter/foundation.dart';
import 'package:ride_card_app/classes/SquareAPIs/services/services.dart';

/*class SquareRepository {
  /*final SquareService _squareService = SquareService();

  Future<Map<String, dynamic>> addCustomer({
    required String idempotencyKey,
    required String givenName,
    required String familyName,
    required String emailAddress,
    required String birthday,
  }) async {
    final customerData = {
      "idempotencyKey": idempotencyKey,
      'given_name': givenName,
      'family_name': familyName,
      "email_address": emailAddress,
      // "birthday": birthday,
    };

    try {
      final response = await _squareService.createCustomer(customerData);
      return response;
    } catch (error) {
      throw Exception('Error adding customer: $error');
    }
  }*/
  final SquareService _squareService = SquareService();

  Future<Map<String, dynamic>> addCustomer({
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
    // Preparing the customer data
    final Map<String, dynamic> customerData = {
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
      "note": note ?? ""
    };

    // Call the service to create the customer
    try {
      final response = await _squareService.createCustomer(customerData);
      print('Customer created successfully: $response');
      return response;
    } catch (error) {
      print('Error in SquareRepository: $error');
      throw Exception('Error adding customer');
    }
  }
}
*/

class SquareRepository {
  final SquareService _squareService = SquareService();

  Future<Map<String, dynamic>> addCustomer({
    required String birthday,
    required String emailAddress,
    required String familyName,
    required String idempotencyKey,
    required String givenName,
  }) async {
    // Preparing the customer data
    final Map<String, dynamic> customerData = {
      "birthday": birthday,
      "email_address": emailAddress,
      "family_name": familyName,
      "idempotency_key": idempotencyKey,
      "given_name": givenName,
    };

    // Call the service to create the customer
    try {
      final response = await _squareService.createCustomer(customerData);
      print('Customer created successfully: $response');
      return response;
    } catch (error) {
      print('Error in SquareRepository: $error');
      throw Exception('Error adding customer');
    }
  }
}
