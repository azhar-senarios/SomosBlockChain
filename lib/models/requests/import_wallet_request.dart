import '../../all_utills.dart';

class ImportWalletRequest extends ApiRequest {
  ImportWalletRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/import-wallet',
    required this.password,
    required this.phrase,
  });

  final String password;
  final String phrase;

  @override
  Future<Response> toCallback() {
    return super.dio.post(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'recovery_phrase': phrase,
    };
  }
}
