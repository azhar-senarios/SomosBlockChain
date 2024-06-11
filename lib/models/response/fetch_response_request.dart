import '../../all_utills.dart';

class FetchSignatureResponse extends ApiResponse {
  const FetchSignatureResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory FetchSignatureResponse.fromJson(Map<String, dynamic> json) {
    return FetchSignatureResponse(
      status: json['success'] ?? false,
      body: json['data']?['count'] ?? 0,
      message: json['message'],
    );
  }
}
