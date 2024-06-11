import 'api_response.dart';

class VerifyPasswordResponse extends ApiResponse {
  const VerifyPasswordResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory VerifyPasswordResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPasswordResponse(
      status: json['success'] ?? false,
      body: {},
      message: json['message'],
    );
  }
}
