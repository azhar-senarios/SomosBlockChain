import '../../all_utills.dart';

class RevealPasswordPhraseRequest extends ApiRequest {
  final String password;

  RevealPasswordPhraseRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/wallet/reveal-phrase',
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
