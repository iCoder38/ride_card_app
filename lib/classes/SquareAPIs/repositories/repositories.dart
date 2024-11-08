import 'package:flutter/foundation.dart';
import 'package:ride_card_app/classes/SquareAPIs/services/services.dart';

class SquareRepository {
  final SquareService _squareService = SquareService();

  Future<Map<String, dynamic>> addCustomer({
    required String idempotencyKey,
    required String givenName,
    required String familyName,
    required String emailAddress,
    required String birthday,
  }) async {
    final customerData = {
      "idempotency_key": idempotencyKey,
      givenName: givenName,
      familyName: familyName,
      "email_address": emailAddress,
      "birthday": birthday,
    };

    try {
      final response = await _squareService.createCustomer(customerData);
      return response;
    } catch (error) {
      throw Exception('Error adding customer: $error');
    }
  }
}
