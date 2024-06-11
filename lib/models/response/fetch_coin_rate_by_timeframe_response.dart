import 'dart:developer'; // Import for logging

import 'api_response.dart';

class CoinRateInRange {
  final String? symbol;
  final String? startDate;
  final String? endDate;
  final List<RateModel> rates;

  const CoinRateInRange({
    required this.symbol,
    required this.rates,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'rates': rates.map((rate) => rate.toJson()).toList(),
    };
  }

  factory CoinRateInRange.fromJson(Map<String, dynamic> json) {
    final rates = (json['rates'] as Map<String, dynamic>?) ?? {};
    final startDate = json['start_date'];
    final endDate = json['end_date'];
    if (rates.isEmpty) return const CoinRateInRange(symbol: null, rates: []);

    final symbol =
        rates.values.map((e) => e.keys.first).where((s) => s != null).first;

    if (symbol == null) return const CoinRateInRange(symbol: null, rates: []);

    final List<RateModel> rateModel = [];

    for (final element in rates.entries) {
      if (element.key.isNotEmpty) {
        try {
          final rateData = element.value[symbol];
          final updatedRateModel = RateModel(
              date: element.key,
              rates: rateData['rate'] ?? 0.0,
              high: (rateData['high']?.toString()) ?? '',
              low: (rateData['low']?.toString()) ?? '',
              vol: (rateData['vol']?.toString()) ?? '',
              cap: (rateData['cap']?.toString()) ?? '',
              sup: (rateData['sup']?.toString()) ?? '');
          rateModel.add(updatedRateModel);
        } on FormatException catch (e) {
          log('Error parsing data: ${element.key}, error: $e');
          // Handle parsing exception (optional: provide default value)
        }
      }
    }

    return CoinRateInRange(
        symbol: symbol,
        rates: rateModel,
        startDate: startDate,
        endDate: endDate);
  }

  @override
  String toString() {
    return 'CoinRateInRange{symbol: $symbol, startDate: $startDate, endDate: $endDate, rates: $rates}';
  }
}

class FetchCoinRateByTimeFrameResponse extends ApiResponse {
  const FetchCoinRateByTimeFrameResponse({
    required super.status,
    required super.body,
    super.message,
  });

  Map<String, dynamic> toMap() {
    return {};
  }

  factory FetchCoinRateByTimeFrameResponse.fromJson(Map<String, dynamic> json) {
    return FetchCoinRateByTimeFrameResponse(
      status: json['success'] ?? false,
      body: CoinRateInRange.fromJson(json),
    );
  }
}

class RateModel {
  final String date;
  final double rates;
  final String high;
  final String low;
  final String vol;
  final String cap;
  final String sup;

  RateModel({
    required this.date,
    required this.rates,
    required this.high,
    required this.low,
    required this.vol,
    required this.cap,
    required this.sup,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'rates': rates,
      'high': high,
      'low': low,
      'vol': vol,
      'cap': cap,
      'sup': sup,
    };
  }

  @override
  String toString() {
    return 'RateModel{date: $date, rates: $rates}';
  }
}
