import '../../all_utills.dart';

class DeleteAccountResponse extends ApiResponse {
  const DeleteAccountResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      status: json['success'] ?? false,
      body: json['data']?['count'] ?? 0,
      message: json['message'],
    );
  }
}
