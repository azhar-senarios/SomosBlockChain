import 'api_response.dart';

class VerifyPasswordPhaseResponse extends ApiResponse {
  VerifyPasswordPhaseResponse({
    required super.status,
    required super.message,
    super.body,
  });

  factory VerifyPasswordPhaseResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPasswordPhaseResponse(
      status: json['success'] ?? false,
      message: json['message'],
      body: json['body'],
    );
  }
}
