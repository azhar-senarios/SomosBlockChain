import '../../all_utills.dart';

class RevealPasswordPhraseResponse extends ApiResponse {
  const RevealPasswordPhraseResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory RevealPasswordPhraseResponse.fromJson(Map<String, dynamic> json) {
    return RevealPasswordPhraseResponse(
      message: json['message'],
      status: json['success'] ?? false,
      body: json['data']?['recovery_phrase'],
    );
  }
}
