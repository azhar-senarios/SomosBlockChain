import '../../all_utills.dart';

const currentCurrency = 'USD';

class FetchRecentRatesRequest extends ApiRequest {
  FetchRecentRatesRequest({
    super.apiUrl =
        'https://api.coinlayer.com/api/live?access_key=$apiKey&target=$currentCurrency&expand=1',
  });

  @override
  Future<Response> toCallback() {
    return super.dio.get(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
