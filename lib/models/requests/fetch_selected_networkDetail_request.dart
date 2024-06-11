import '../../all_utills.dart';

class FetchSelectedNetworkDetailRequest extends ApiRequest {
  FetchSelectedNetworkDetailRequest({
    required this.currentNetwork,
    required this.currentAccountAddress,
    super.apiUrl = '${ApiConstants.baseUrl}/network/switch-network',
  });
  final String currentNetwork;
  final String currentAccountAddress;
  @override
  Future<Response> toCallback() {
    return dio.post(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'address': currentAccountAddress,
      'networkName': currentNetwork,
    };
  }
}
