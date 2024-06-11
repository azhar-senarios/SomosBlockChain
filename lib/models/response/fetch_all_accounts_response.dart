import '../../all_utills.dart';

class Account {
  final String id;
  final String name;
  final String address;
  final DateTime createdAt;

  const Account({
    required this.id,
    required this.name,
    required this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'wallet_id': id,
      'account_name': name,
      'account_address': address,
      'created_at': createdAt,
    };
  }

  factory Account.fromJson(Map<String, dynamic> map) {
    return Account(
      id: map['wallet_id'] as String,
      name: map['account_name'] as String,
      address: map['account_address'] as String,
      createdAt: DateTime.parse(map['created_at'].toString()),
    );
  }
}

class FetchAllAccountsResponse extends ApiResponse {
  FetchAllAccountsResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory FetchAllAccountsResponse.fromJson(Map<String, dynamic> json) {
    final accounts = (json['data'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(Account.fromJson)
        .toList();

    return FetchAllAccountsResponse(
      status: json['success'] ?? false,
      message: json['message'],
      body: accounts,
    );
  }
}
