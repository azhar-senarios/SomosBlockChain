import '../../all_utills.dart';

class CoinDetails {
  CoinDetails({
    required this.name,
    required this.symbol,
    required this.imageUrl,
  });

  String name;
  String symbol;
  String imageUrl;

  factory CoinDetails.fromJson(Map<String, dynamic> json) => CoinDetails(
        name: json['name'],
        symbol: json['symbol'],
        imageUrl: json['image_url'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'symbol': symbol,
        'image_url': imageUrl,
      };
}

class FetchCoinImagesResponse extends ApiResponse {
  FetchCoinImagesResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory FetchCoinImagesResponse.fromJson(Map<String, dynamic> json) {
    final coins = <String, CoinDetails>{};

    for (final json in (json['data'] as List<dynamic>? ?? [])) {
      final coin = CoinDetails.fromJson(json);

      coins.putIfAbsent(coin.symbol, () => coin);
    }

    return FetchCoinImagesResponse(
      message: json['message'],
      body: coins,
      status: json['success'] ?? false,
    );
  }
}
