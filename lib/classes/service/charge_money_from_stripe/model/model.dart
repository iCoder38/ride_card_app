class ChargeRequest {
  final String action;
  final String userId;
  final double amount;
  final String tokenID;

  ChargeRequest({
    required this.action,
    required this.userId,
    required this.amount,
    required this.tokenID,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'userId': userId,
      'amount': amount,
      'tokenID': tokenID,
    };
  }
}

class ChargeResponse {
  final String status;
  final String message;

  ChargeResponse({required this.status, required this.message});

  factory ChargeResponse.fromJson(Map<String, dynamic> json) {
    return ChargeResponse(
      status: json['status'],
      message: json['message'] ?? '',
    );
  }
}
