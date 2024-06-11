import '../../all_utills.dart';

class VerifyPasswordPhraseRequest extends ApiRequest {
  VerifyPasswordPhraseRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/wallet/verify-phrase',
    required this.words,
  });

  final List<String> words;

  @override
  Future<Response> toCallback() {
    return super.dio.get(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'phrase': words.join(' ').toString().trim(),
      // 'phrase':
      //     'follow biology over autumn day switch awake repair inner vapor drink target',
    };
  }
}
