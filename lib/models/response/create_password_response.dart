import 'api_response.dart';

class CreatePasswordModel {
  final String authToken;
  final String recoveryPhrase;

  const CreatePasswordModel({
    required this.authToken,
    required this.recoveryPhrase,
  });

  factory CreatePasswordModel.fromJson(Map<String, dynamic> json) {
    return CreatePasswordModel(
      authToken: json['access_token'],
      recoveryPhrase: json['recovery_phrase'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': authToken,
      'recovery_phrase': recoveryPhrase,
    };
  }
}

class CreatePasswordResponse extends ApiResponse {
  const CreatePasswordResponse({
    required super.status,
    required super.body,
    required super.message,
  });

  factory CreatePasswordResponse.fromJson(Map<String, dynamic> json) {
    return CreatePasswordResponse(
      status: json['success'] ?? false,
      body: CreatePasswordModel.fromJson(json['data']),
      message: json['message'],
    );
  }
}
