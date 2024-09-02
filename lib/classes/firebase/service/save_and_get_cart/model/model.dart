import 'package:uuid/uuid.dart';

class CardModel {
  final String userId;
  final String cardHolderName;
  final String cardNumber;
  final String cardExpMonth;
  final String cardExpYear;
  final String cardId;
  final bool cardStatus;

  CardModel({
    required this.userId,
    required this.cardHolderName,
    required this.cardNumber,
    required this.cardExpMonth,
    required this.cardExpYear,
    required this.cardId,
    required this.cardStatus,
  });

  // Factory method to create a CardModel from a map (useful for fetching from Firestore)
  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      userId: map['userId'],
      cardHolderName: map['cardHolderName'],
      cardNumber: map['cardNumber'],
      cardExpMonth: map['cardExpMonth'],
      cardExpYear: map['cardExpYear'],
      cardId: map['cardId'],
      cardStatus: map['cardStatus'],
    );
  }

  // Method to convert a CardModel instance to a map (useful for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'cardExpMonth': cardExpMonth,
      'cardExpYear': cardExpYear,
      'cardId': cardId,
      'cardStatus': cardStatus,
    };
  }
}
