import '../../all_utills.dart';

class FetchSignatureRequest extends ApiRequest {
  FetchSignatureRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/sign-url',
    this.queryParam,
  });
  final Map<String, dynamic>? queryParam;
  @override
  Future<Response> toCallback() {
    return dio.get(super.apiUrl, data: queryParam);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'url': 'https://buy-sandbox.moonpay.com/',
      'currencyCode': 'ETH',
      'walletAddress': '0x2a0db32b212f81ea1db276d757941773ad3ecb38'
    };
  }
}
