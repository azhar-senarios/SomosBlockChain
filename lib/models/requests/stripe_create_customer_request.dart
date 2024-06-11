import '../../all_utills.dart';

class StripeCustomerRequest extends ApiRequest {
  StripeCustomerRequest({
    super.apiUrl = '${ApiConstants.baseUrl}/payment/create-customer',
    required this.tierId,
  });

  final String tierId;

  @override
  Future<Response> toCallback() {
    return super.dio.post(super.apiUrl, data: toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {'tierId': tierId};
  }
}
