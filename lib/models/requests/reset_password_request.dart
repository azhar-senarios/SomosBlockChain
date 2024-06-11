import '../../all_utills.dart';

class ResetPasswordRequest extends ApiRequest {
  final String currentPassword;
  final String newPassword;

  ResetPasswordRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/wallet/reset-password',
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  Future<Response> toCallback() {
    return dio.post(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'password': currentPassword,
      'newPassword': newPassword,
    };
  }
}
