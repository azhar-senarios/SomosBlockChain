import '../../all_utills.dart';

class FetchCoinRateByTimeFrameRequest extends ApiRequest {
  final String symbol;
  final DateTime startDate;
  final DateTime endDate;

  FetchCoinRateByTimeFrameRequest({
    super.apiUrl = 'https://api.coinlayer.com/timeframe',
    required this.symbol,
    required this.endDate,
    required this.startDate,
  });

  @override
  Future<Response> toCallback() {
    final url =
        '${super.apiUrl}?access_key=$apiKey&start_date=${endDate.toYYYYMMDD()}&end_date=${startDate.toYYYYMMDD()}&symbols=$symbol&expand=1';

    return super.dio.get(url, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
