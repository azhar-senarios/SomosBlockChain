import 'api_response.dart';

class StripeCustomerResponseModel {
  final String customerId;
  final PaymentIntent paymentIntent;

  StripeCustomerResponseModel({
    required this.customerId,
    required this.paymentIntent,
  });

  factory StripeCustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return StripeCustomerResponseModel(
      customerId: json['customerId'],
      paymentIntent: PaymentIntent.fromJson(json['paymentIntent']),
    );
  }
}

class PaymentIntent {
  final String paymentIntentId;
  final int amount;
  final String clientSecret;

  PaymentIntent({
    required this.paymentIntentId,
    required this.amount,
    required this.clientSecret,
  });

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    return PaymentIntent(
      paymentIntentId: json['paymentIntentId'],
      amount: json['Amount'],
      clientSecret: json['client_secret'],
    );
  }
}

class StripeCreateCustomerResponse extends ApiResponse {
  const StripeCreateCustomerResponse({
    required super.status,
    required super.message,
    super.body,
  });

  factory StripeCreateCustomerResponse.fromJson(Map<String, dynamic> json) {
    return StripeCreateCustomerResponse(
      status: json['success'] ?? false,
      message: json['message'],
      body: StripeCustomerResponseModel.fromJson(json['data']),
    );
  }
}
