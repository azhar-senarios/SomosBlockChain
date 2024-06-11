import '../../all_utills.dart';

class UpdateFCMTokenResponse extends ApiResponse {
  const UpdateFCMTokenResponse({
    required super.status,
    required super.message,
    required super.body,
  });

  factory UpdateFCMTokenResponse.fromJson(Map<String, dynamic> json) {
    return UpdateFCMTokenResponse(
      body: json['data'],
      status: json['success'] ?? false,
      message: json['message'],
    );
  }
}
