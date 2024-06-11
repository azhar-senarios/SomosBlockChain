import '../../all_utills.dart';

class FetchBrainTreeToken extends ApiRequest {
  FetchBrainTreeToken({
    super.apiUrl = '${ApiConstants.baseUrl}/braintree/client-token',
  });
  @override
  Future<Response> toCallback() {
    return super.dio.get(super.apiUrl);
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
