import '../../all_utills.dart';

class CryptoDetailModel {
  final String currency;
  final String rate;
  final String high;
  final String low;
  final String vol;
  final String cap;
  final String sup;
  final double change;
  final double changePct;

  CryptoDetailModel({
    required this.currency,
    required this.rate,
    required this.high,
    required this.low,
    required this.vol,
    required this.cap,
    required this.sup,
    required this.change,
    required this.changePct,
  });

  factory CryptoDetailModel.fromJson(Map<String, dynamic> json) {
    final rates = json['rates'] as Map<String, dynamic>;
    final currencyData = rates.isNotEmpty ? rates.keys.first : null;
    final ethData = rates[currencyData] as Map<String, dynamic>;

    return CryptoDetailModel(
      currency: currencyData ?? 'ETH',
      rate: ethData['rate'].toString(),
      high: ethData['high'].toString(),
      low: ethData['low'].toString(),
      vol: ethData['vol'].toString(),
      cap: ethData['cap'].toString(),
      sup: ethData['sup'].toString(),
      change:
          double.parse(ethData['change'].toString()), // Parse change to double
      changePct: double.parse(ethData['change_pct'].toString()),
    );
  }

  // Add a toJson method for serialization
  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'rate': rate,
      'high': high,
      'low': low,
      'vol': vol,
      'cap': cap,
      'sup': sup,
      'change': change, // Include change in JSON
      'changePct': changePct,
    };
  }
}

class FetchCurrencyPriceResponse extends ApiResponse {
  FetchCurrencyPriceResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory FetchCurrencyPriceResponse.fromJson(Map<String, dynamic> json) {
    return FetchCurrencyPriceResponse(
      status: json['success'] ?? false,
      body: json,
      message: json.isEmpty ? null : json['message'],
    );
  }
}
