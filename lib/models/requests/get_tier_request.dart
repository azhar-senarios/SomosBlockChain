import '../../all_utills.dart';

class GetTierRequest extends ApiRequest {
  GetTierRequest({super.apiUrl = '${ApiConstants.baseUrl}/tier/fetch-all'});

  @override
  Future<Response> toCallback() {
    return super.dio.get(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
