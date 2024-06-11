import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../all_utills.dart';
import '../../../models/response/stripe_create_customer_response.dart';

class PaymentController {
  static const publishableKey =
      'pk_test_51O2ya8LekhWLe87KXjqnpRQi9BBgE7jQG2Yq25EBUenjki6LJ4OlPRcaunUPVMKRbcdZfQxdT5gLRILwpnYSLINw00wKPCAUd3';

  static Future<void> initialize() async {
    Stripe.publishableKey = publishableKey;
    Stripe.merchantIdentifier = 'merchant.com.somos';
    await Stripe.instance.applySettings();
  }

  static Future<bool> initPayment(
    StripeCustomerResponseModel stripeResponse,
  ) async {
    try {
      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
          googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: 'US', testEnv: true),
          paymentIntentClientSecret: stripeResponse.paymentIntent.clientSecret,
          customerId: stripeResponse.customerId,
          merchantDisplayName: 'Somos',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (error) {
      if (error is StripeException) {
        Utils.displayToast(error.error.message);
        return false;
      } else {
        Utils.displayToast(error.toString());
        return false;
      }
    }
  }
}
