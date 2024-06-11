import '../../all_utills.dart';

const apiKey = 'ffee53d11858e2dd8e3a553e2b4eaf59';

class FetchCoinDetailRequest extends ApiRequest {
  FetchCoinDetailRequest({
    required this.symbol,
    super.apiUrl =
        'https://api.coinlayer.com/api/live?access_key=$apiKey&expand=1',
  });
  final String symbol;
  @override
  Future<Response> toCallback() {
    return super.dio.get(super.apiUrl, queryParameters: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {'symbols': symbol};
  }
}
