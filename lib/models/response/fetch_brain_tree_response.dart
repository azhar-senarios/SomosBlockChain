import 'package:somos_app/models/response/api_response.dart';

class FetchBrainTreeResponse extends ApiResponse {
  FetchBrainTreeResponse({
    required super.status,
    required super.body,
    required String super.message,
  });

  factory FetchBrainTreeResponse.fromJson(Map<String, dynamic> json) {
    return FetchBrainTreeResponse(
      status: json['success'] ?? false,
      message: json['message'],
      body: json['data'] != null && json['data'] != {} ? json['data'] : null,
    );
  }
}
