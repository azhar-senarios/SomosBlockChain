import '../../all_utills.dart';

class UpdateFCMTokenRequest extends ApiRequest {
  final String token;

  UpdateFCMTokenRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/fcm/update',
    required this.token,
  });

  @override
  Future<Response> toCallback() {
    return super.dio.post(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {'fcm_Token': token};
  }
}
