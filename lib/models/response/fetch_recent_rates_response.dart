import 'package:somos_app/models/response/api_response.dart';
import 'package:somos_app/models/response/fetch_coin_images_response.dart';

class CoinRate {
  final String symbol;
  final double price;
  final double low;
  final double high;
  final double volume;
  final double capacity;
  final double supply;
  final double change;
  final double changePercent;
  CoinDetails? details;

  CoinRate({
    required this.symbol,
    required this.price,
    required this.low,
    required this.high,
    required this.volume,
    required this.capacity,
    required this.supply,
    required this.change,
    required this.changePercent,
    this.details,
  });

  get imageUrl => details?.imageUrl;
  get name => details?.name;

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'rate': price,
      'low': low,
      'high': high,
      'vol': volume,
      'cap': capacity,
      'sup': supply,
      'change': change,
      'change_pct': changePercent,
    };
  }

  factory CoinRate.fromJson(Map<String, dynamic> map, String symbol) {
    return CoinRate(
      symbol: symbol,
      price: double.parse((map['rate'] ?? 0.0).toString()),
      low: double.parse((map['low'] ?? 0.0).toString()),
      high: double.parse((map['high'] ?? 0.0).toString()),
      volume: double.parse((map['vol'] ?? 0.0).toString()),
      capacity: double.parse((map['cap'] ?? 0.0).toString()),
      supply: double.parse((map['sup'] ?? 0.0).toString()),
      change: double.parse((map['change'] ?? 0.0).toString()),
      changePercent: double.parse((map['change_pct'] ?? 0.0).toString()),
    );
  }
}

class FetchRecentRatesResponse extends ApiResponse {
  FetchRecentRatesResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory FetchRecentRatesResponse.fromJson(Map<String, dynamic> json) {
    final rates = (json['rates'] as Map<String, dynamic>? ?? {})
        .entries
        .map<CoinRate>((e) {
      return CoinRate.fromJson(e.value, e.key);
    }).toList();

    // rates.sort((rate1, rate2) => rate2.price.compareTo(rate1.price));

    return FetchRecentRatesResponse(
      status: json['success'] ?? false,
      body: rates,
      message: json['message'],
    );
  }
}
