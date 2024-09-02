// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:ride_card_app/classes/common/tax_and_fees/card_show/model/model.dart';

// Future<CardDetailsForTaxAndFees?> showCardBottomSheet(
//     BuildContext context) async {
//   final TextEditingController cardholderNameController =
//       TextEditingController();
//   final TextEditingController cardNumberController = TextEditingController();
//   final TextEditingController expMonthController = TextEditingController();
//   final TextEditingController expYearController = TextEditingController();
//   final TextEditingController cvvController = TextEditingController();

//   return await showModalBottomSheet<CardDetailsForTaxAndFees>(
//     context: context,
//     isScrollControlled: true,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: 20,
//           right: 20,
//           top: 20,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Cardholder Name
//             TextField(
//               controller: cardholderNameController,
//               decoration: InputDecoration(
//                 labelText: 'Cardholder Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             // Card Number
//             TextField(
//               controller: cardNumberController,
//               keyboardType: TextInputType.number,
//               maxLength: 16,
//               decoration: InputDecoration(
//                 labelText: 'Card Number',
//                 border: OutlineInputBorder(),
//               ),
//               inputFormatters: [
//                 // Add validation for 16 digits
//                 FilteringTextInputFormatter.digitsOnly,
//               ],
//             ),
//             SizedBox(height: 10),
//             // Expiration Date and CVV
//             Row(
//               children: [
//                 // Expiration Month
//                 Expanded(
//                   child: TextField(
//                     controller: expMonthController,
//                     keyboardType: TextInputType.number,
//                     maxLength: 2,
//                     decoration: InputDecoration(
//                       labelText: 'Exp. Month',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 // Expiration Year
//                 Expanded(
//                   child: TextField(
//                     controller: expYearController,
//                     keyboardType: TextInputType.number,
//                     maxLength: 2,
//                     decoration: InputDecoration(
//                       labelText: 'Exp. Year',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 // CVV
//                 Expanded(
//                   child: TextField(
//                     controller: cvvController,
//                     keyboardType: TextInputType.number,
//                     maxLength: 3,
//                     decoration: InputDecoration(
//                       labelText: 'CVV',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             // Submit Button
//             ElevatedButton(
//               onPressed: () {
//                 // Check if all fields are filled
//                 if (cardholderNameController.text.isNotEmpty &&
//                     cardNumberController.text.length == 16 &&
//                     expMonthController.text.isNotEmpty &&
//                     expYearController.text.isNotEmpty &&
//                     cvvController.text.length == 3) {
//                   // Create CardDetails object
//                   final cardDetails = CardDetailsForTaxAndFees(
//                     cardholderName: cardholderNameController.text,
//                     cardNumber: cardNumberController.text,
//                     expMonth: expMonthController.text,
//                     expYear: expYearController.text,
//                     cvv: cvvController.text,
//                   );

//                   // Return the card details
//                   Navigator.pop(context, cardDetails);
//                 } else {
//                   // Show a message if validation fails
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text('Please fill in all fields correctly.')),
//                   );
//                 }
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ride_card_app/classes/common/tax_and_fees/card_show/model/model.dart';

Future<dynamic> showCardBottomSheet(BuildContext context) async {
  final TextEditingController cardholderNameController =
      TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expMonthController = TextEditingController();
  final TextEditingController expYearController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  bool topButtonClicked = false;
  bool saveCard = false;

  return await showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Clickable Top Button Text
                GestureDetector(
                  onTap: () {
                    topButtonClicked = true;
                    Navigator.pop(context, {'topButtonClicked': true});
                  },
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Saved card',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Cardholder Name
                TextField(
                  controller: cardholderNameController,
                  decoration: const InputDecoration(
                    labelText: 'Cardholder Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // Card Number
                TextField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 10),
                // Expiration Date and CVV
                Row(
                  children: [
                    // Expiration Month
                    Expanded(
                      child: TextField(
                        controller: expMonthController,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: const InputDecoration(
                          labelText: 'Exp. Month',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Expiration Year
                    Expanded(
                      child: TextField(
                        controller: expYearController,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: const InputDecoration(
                          labelText: 'Exp. Year',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // CVV
                    Expanded(
                      child: TextField(
                        controller: cvvController,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Save Card Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: saveCard,
                      onChanged: (bool? value) {
                        setState(() {
                          saveCard = value ?? false;
                        });
                      },
                    ),
                    const Text('Save this card for payments'),
                  ],
                ),
                const SizedBox(height: 20),
                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (cardholderNameController.text.isNotEmpty &&
                        cardNumberController.text.length == 16 &&
                        expMonthController.text.isNotEmpty &&
                        expYearController.text.isNotEmpty &&
                        cvvController.text.length == 3) {
                      final cardDetails = CardDetailsForTaxAndFees(
                        cardholderName: cardholderNameController.text,
                        cardNumber: cardNumberController.text,
                        expMonth: expMonthController.text,
                        expYear: expYearController.text,
                        cvv: cvvController.text,
                        saveCard: saveCard,
                      );

                      Navigator.pop(context, {
                        'topButtonClicked': false,
                        'cardDetails': cardDetails,
                        'saveCard': saveCard
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields correctly.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
