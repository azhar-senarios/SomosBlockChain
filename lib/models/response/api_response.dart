abstract class ApiResponse {
  final bool status;
  final String? message;
  final dynamic body;

  const ApiResponse({required this.status, this.message, this.body});

  // TODO find a way to make sure that each response integrates fromJson (factory) method
  // by making it abstract or some other way
  // ApiResponse fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': body,
    };
  }
}
