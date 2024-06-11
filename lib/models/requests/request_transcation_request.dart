import '../../all_utills.dart';

class RequestTranscationHistory extends ApiRequest {
  RequestTranscationHistory(
      {super.apiUrl = '${ApiConstants.baseUrl}/transaction/fetch-all',
      required this.accountAddress});
  final String accountAddress;

  @override
  Future<Response> toCallback() {
    return super.dio.get(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {'accountAddress': accountAddress};
  }
}
