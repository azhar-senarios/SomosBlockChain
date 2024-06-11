import '../../all_utills.dart';

class RevealSecretKeyResponse extends ApiResponse {
  RevealSecretKeyResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory RevealSecretKeyResponse.fromJson(Map<String, dynamic> json) {
    return RevealSecretKeyResponse(
      status: json['success'] ?? false,
      message: json['message'],
      body: json['data']?['secret_key'] ?? '',
    );
  }
}
