import '../../all_utills.dart' as get_all_network_response;

class NetworkModel {
  final String name;
  final String currency;
  final String logoUrl;

  NetworkModel({
    required this.name,
    required this.currency,
    required this.logoUrl,
  });

  factory NetworkModel.fromJson(Map<String, dynamic> json) {
    return NetworkModel(
      name: json['name'],
      currency: json['currency'],
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'currency': currency,
      'logoUrl': logoUrl,
    };
  }
}

class FetchAllNetworkResponse extends get_all_network_response.ApiResponse {
  FetchAllNetworkResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory FetchAllNetworkResponse.fromJson(Map<String, dynamic> json) {
    final networks = (json['data'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(NetworkModel.fromJson)
        .toList();

    return FetchAllNetworkResponse(
      status: json['success'] ?? false,
      message: json['message'],
      body: networks,
    );
  }
}
