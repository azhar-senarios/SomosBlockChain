import 'api_response.dart';

class TierSubscriptionModel {
  final List<Tiers>? tiers;
  final bool purchased;

  TierSubscriptionModel({this.tiers, this.purchased = false});

  TierSubscriptionModel.fromJson(Map<String, dynamic> json)
      : tiers = (json['tiers'] as List<dynamic>?)
            ?.map((e) => Tiers.fromJson(e as Map<String, dynamic>))
            .toList(),
        purchased = json['purchased'] ?? false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (tiers != null) {
      data['tiers'] = tiers!.map((e) => e.toJson()).toList();
    }
    data['purchased'] = purchased;
    return data;
  }
}

class Tiers {
  String? tierId;
  final String? type;
  final String? amount;
  final String? stripeProductId;
  final String? description;

  Tiers({
    this.tierId,
    this.type,
    this.amount,
    this.stripeProductId,
    this.description,
  });

  Tiers.fromJson(Map<String, dynamic> json)
      : tierId = json['tier_id'],
        type = json['type'],
        amount = json['amount'],
        stripeProductId = json['stripe_product_id'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['tier_id'] = tierId;
    data['type'] = type;
    data['amount'] = amount;
    data['stripe_product_id'] = stripeProductId;
    data['description'] = description;
    return data;
  }
}

class TierModelResponse extends ApiResponse {
  TierModelResponse({
    required super.status,
    required super.body,
    required String super.message,
  });

  factory TierModelResponse.fromJson(Map<String, dynamic> json) {
    return TierModelResponse(
      status: json['success'] ?? false,
      message: json['message'],
      body: json['data'] != null && json['data'] != {}
          ? TierSubscriptionModel.fromJson(json['data'])
          : null,
    );
  }
}
