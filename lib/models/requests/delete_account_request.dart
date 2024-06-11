import '../../all_utills.dart';

class DeleteAccountRequest extends ApiRequest {
  final String accountAddress;

  DeleteAccountRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/account/delete',
    required this.accountAddress,
  });

  @override
  Future<Response> toCallback() {
    return super.dio.delete(super.apiUrl, queryParameters: {
      'account_address': accountAddress,
    });
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
