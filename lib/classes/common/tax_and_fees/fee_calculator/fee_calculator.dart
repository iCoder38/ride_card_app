import 'package:flutter/foundation.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';

class FeeCalculator {
  static double calculateFee(
    String feesAndTaxesType,
    double feesAndTaxesAmount,
  ) {
    double calculatedFeeAmount;

    double doubleFeesAmount = feesAndTaxesAmount;

    if (feesAndTaxesType == TAX_TYPE_PERCENTAGE) {
      // calculate and convert for stripe also

      // double percentage = 6.0; // This is the percentage value from the server
      /*double decimalValue = (doubleFeesAmount * 10) / 100; // Convert to decimal
      if (kDebugMode) {
        print('========> $decimalValue');
      }
      String formattedValue = decimalValue.toStringAsFixed(2);
      calculatedFeeAmount = double.parse(formattedValue.toString());*/
      // This will print 0.60
      calculatedFeeAmount = doubleFeesAmount * 10;
    } else if (feesAndTaxesType == TAX_TYPE_FIXED_PRICE) {
      calculatedFeeAmount = doubleFeesAmount;
    } else {
      debugPrint('NO, Fees and Taxes');
      calculatedFeeAmount = 0.0;
    }

    debugPrint('Calculated Amount is: ==> ${calculatedFeeAmount.toString()}');
    return calculatedFeeAmount;
  }
}
