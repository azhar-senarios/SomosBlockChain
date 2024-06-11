import 'package:somos_app/models/response/send_crypto_response.dart';

import '../../all_utills.dart';

class SendCryptoRequest extends ApiRequest {
  final SendCryptoModel sendCryptoModel;

  SendCryptoRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/send-crypto',
    required this.sendCryptoModel,
  });

  @override
  Future<Response> toCallback() {
    return super.dio.post(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    final data = sendCryptoModel.toJson();
    print(sendCryptoModel.amount);
    return data;
  }
}
