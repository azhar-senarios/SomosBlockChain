import '../../all_utills.dart';

class VerifyPasswordRequest extends ApiRequest {
  final String password;

  VerifyPasswordRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/wallet/verify-password',
    required this.password,
  });

  @override
  Future<Response> toCallback() {
    final dio = super.dio.get(super.apiUrl, data: toJson());
    return dio;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'password': password,
    };
  }
}
