import '../../all_utills.dart';

class FetchCoinImagesRequest extends ApiRequest {
  FetchCoinImagesRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/currency/fetch-all',
    this.queryParam,
  });
  final Map<String, dynamic>? queryParam;
  @override
  Future<Response> toCallback() {
    return dio.get(super.apiUrl, queryParameters: queryParam);
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
