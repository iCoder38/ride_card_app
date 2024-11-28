import 'package:flutter/material.dart';

//
//
class SavedCardDetails {
  final String cardNumber;
  final String cardholderName;
  final String expMonth;
  final String expYear;
  final String cvv;

  SavedCardDetails({
    required this.cardNumber,
    required this.cardholderName,
    required this.expMonth,
    required this.expYear,
    required this.cvv,
  });
}

Future<SavedCardDetails?> showCardDetailsDialog(
    BuildContext context, SavedCardDetails cardDetails) async {
  final TextEditingController cvvController = TextEditingController();

  return showDialog<SavedCardDetails>(
    context: context,
    barrierDismissible: false, // User must click button to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Card Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Card Number: ${cardDetails.cardNumber}'),
              const SizedBox(height: 10),
              Text('Cardholder Name: ${cardDetails.cardholderName}'),
              const SizedBox(height: 10),
              Text('Exp. Month: ${cardDetails.expMonth}'),
              const SizedBox(height: 10),
              Text('Exp. Year: ${cardDetails.expYear}'),
              const SizedBox(height: 20),
              // CVV Input
              TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                maxLength: 3,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              if (cvvController.text.length == 3) {
                final updatedCardDetails = SavedCardDetails(
                  cardNumber: cardDetails.cardNumber,
                  cardholderName: cardDetails.cardholderName,
                  expMonth: cardDetails.expMonth,
                  expYear: cardDetails.expYear,
                  cvv: cvvController.text,
                );

                Navigator.of(context).pop(updatedCardDetails);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid CVV.'),
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel button
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
