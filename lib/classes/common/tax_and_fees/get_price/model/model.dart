class FeeData {
  final int id;
  final String name;
  final String type;
  final String amount;

  FeeData({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
  });

  // Factory method to create a FeeData instance from JSON
  factory FeeData.fromJson(Map<String, dynamic> json) {
    return FeeData(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      amount: json['amount'],
    );
  }
}
