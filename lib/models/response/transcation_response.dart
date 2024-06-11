import 'package:somos_app/models/response/api_response.dart';

class FetchTranscationHistoryResponse extends ApiResponse {
  FetchTranscationHistoryResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory FetchTranscationHistoryResponse.fromJson(Map<String, dynamic> json) {
    final jsonList = json['data'] as List<dynamic>;

    List<Transaction> transactions = jsonList
        .map((json) => Transaction.fromJson(json))
        .toList();

    return FetchTranscationHistoryResponse(
      status: json['success'] ?? false,
      body: json.isEmpty ? null :transactions,
      message: json.isEmpty ? null : json['message'],
    );
  }
}
class Transaction {
  String txnId;
  String senderAddress;
  String receiverAddress;
  String amount;
  String txnType;
  String txnStatus;
  String chainType;
  String createdAt;

  Transaction({
    required this.txnId,
    required this.senderAddress,
    required this.receiverAddress,
    required this.amount,
    required this.txnType,
    required this.txnStatus,
    required this.chainType,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      txnId: json['txn_id'],
      senderAddress: json['sender_address'],
      receiverAddress: json['receiver_address'],
      amount: json['amount'],
      txnType: json['txn_type'],
      txnStatus: json['txn_status'],
      chainType: json['chain_type'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'txn_id': txnId,
      'sender_address': senderAddress,
      'receiver_address': receiverAddress,
      'amount': amount,
      'txn_type': txnType,
      'txn_status': txnStatus,
      'chain_type': chainType,
      'created_at': createdAt,
    };
  }
}