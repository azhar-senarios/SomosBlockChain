import '../../all_utills.dart';

class CreatePasswordRequest extends ApiRequest {
  final String password;

  CreatePasswordRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/create-wallet',
    required this.password,
  });

  @override
  Future<Response> toCallback() {
    return super.dio.post(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'password': password,
    };
  }
}
