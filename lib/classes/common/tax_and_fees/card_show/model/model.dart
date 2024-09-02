class CardDetailsForTaxAndFees {
  final String cardholderName;
  final String cardNumber;
  final String expMonth;
  final String expYear;
  final String cvv;
  final bool saveCard;

  CardDetailsForTaxAndFees({
    required this.cardholderName,
    required this.cardNumber,
    required this.expMonth,
    required this.expYear,
    required this.cvv,
    required this.saveCard,
  });
}
