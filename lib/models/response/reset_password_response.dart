import 'api_response.dart';

class ResetPasswordResponse extends ApiResponse {
  const ResetPasswordResponse({
    required super.status,
    required super.message,
    required super.body,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      status: json['success'] ?? false,
      message: json['message'],
      body: json['data'],
    );
  }
}
