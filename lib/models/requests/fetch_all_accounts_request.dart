import '../../all_utills.dart';

class FetchAllAccountsRequest extends ApiRequest {
  FetchAllAccountsRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/account/fetch-all',
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
