import 'api_response.dart';

class ImportWalletResponse extends ApiResponse {
  const ImportWalletResponse({
    required super.status,
    required super.message,
    super.body,
  });

  factory ImportWalletResponse.fromJson(Map<String, dynamic> json) {
    print(json);

    return ImportWalletResponse(
      status: json['success'] ?? false,
      message: json['message'],
      body: json.containsKey('data') ? json['data']['access_token'] : null,
    );
  }
}
