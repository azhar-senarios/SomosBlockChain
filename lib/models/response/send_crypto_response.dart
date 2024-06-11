import '../../all_utills.dart';

class SendCryptoModel {
  String networkName;
  String currency;
  String amount;
  String senderAddress;
  String receiverAddress;

  SendCryptoModel({
    required this.networkName,
    required this.currency,
    required this.amount,
    required this.senderAddress,
    required this.receiverAddress,
  });

  factory SendCryptoModel.fromJson(Map<String, dynamic> json) {
    return SendCryptoModel(
      networkName: json['networkName'],
      currency: json['currency'],
      amount: json['amount'], // Keep amount as string
      senderAddress: json['senderAddress'],
      receiverAddress: json['receiverAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'networkName': networkName,
      'currency': currency,
      'amount': amount,
      'senderAddress': senderAddress,
      'receiverAddress': receiverAddress,
    };
  }
}

class SendCryptoResponse extends ApiResponse {
  SendCryptoResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory SendCryptoResponse.fromJson(Map<String, dynamic> json) {
    return SendCryptoResponse(
      status: json['success'] ?? false,
      message: json['message'],
      body: json['data'],
    );
  }
}
