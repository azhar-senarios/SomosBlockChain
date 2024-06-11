import '../../all_utills.dart';

class RevealSecretKeyRequest extends ApiRequest {
  final String password;

  RevealSecretKeyRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/wallet/reveal-secret-key',
    required this.password,
  });

  @override
  Future<Response> toCallback() {
    return dio.post(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {'password': password};
  }
}
