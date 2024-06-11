import '../../all_utills.dart';

class FetchAllNetworkRequest extends ApiRequest {
  FetchAllNetworkRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/network/fetch-all',
  });

  @override
  Future<Response> toCallback() {
    return dio.get(super.apiUrl, queryParameters: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
