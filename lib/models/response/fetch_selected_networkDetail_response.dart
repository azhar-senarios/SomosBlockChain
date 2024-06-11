import 'package:somos_app/models/response/fetch_crypto_detail_response.dart';

import '../../all_utills.dart' as get_all_network_response;

// Define your model class
class AccountDetail {
  final String network;
  final String address;
  final String balance;
  final String currency;
  final String logoUrl;
  CryptoDetailModel? cryptoData;
  AccountDetail({
    required this.network,
    required this.address,
    required this.balance,
    required this.currency,
    this.cryptoData,
    required this.logoUrl,
  });

  // Factory method to create NetworkData from a JSON map
  factory AccountDetail.fromJson(Map<String, dynamic> json) {
    return AccountDetail(
      network: json['network'],
      address: json['address'],
      balance: json['balance'],
      currency: json['currency'],
      logoUrl: json['logoUrl'],
    );
  }

  // Method to convert NetworkData to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'network': network,
      'address': address,
      'balance': balance,
      'currency': currency,
      'logoUrl': logoUrl,
    };
  }
}

class FetchSelectedNetworkDetailResponse
    extends get_all_network_response.ApiResponse {
  FetchSelectedNetworkDetailResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory FetchSelectedNetworkDetailResponse.fromJson(
      Map<String, dynamic> json) {
    final networks =
        json['data'] != null ? AccountDetail.fromJson(json['data']) : null;

    final data = FetchSelectedNetworkDetailResponse(
      status: json['success'] ?? false,
      message: json['message'],
      body: networks,
    );
    return data;
  }
}
