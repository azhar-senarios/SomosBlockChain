import '../../../all_screen.dart';
import '../../../all_utills.dart';
import '../../../models/requests/stripe_create_customer_request.dart';
import '../../../models/response/get_tier_response.dart';

final swapStateProvider = StateProvider.autoDispose<bool>((ref) => false);

final tierStateProvider =
    FutureProvider.autoDispose<TierSubscriptionModel>((ref) async {
  TierSubscriptionModel response =
      (await homeRepository.getTierResponse()).body;
  bool swapped = ref.read(swapStateProvider.notifier).state;
  if (response.tiers != null && response.tiers!.length == 3 && !swapped) {
    var temp = response.tiers![0];
    response.tiers![0] = response.tiers![1];
    response.tiers![1] = temp;
    ref.read(swapStateProvider.notifier).state =
        true; // Set the swapped state to true
  }
  return response;
});

final popShowStateProvider = StateProvider.autoDispose<bool>((ref) => true);

class PricingPlansScreen extends ConsumerWidget {
  final bool isNotShowAction;
  static const String routeName = '/PricingPlansScreen';
  const PricingPlansScreen({super.key, this.isNotShowAction = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<TierSubscriptionModel> tiers =
        ref.watch(tierStateProvider);

    return tiers.when(
      data: (value) => BaseScaffold(
        appBarTitle: value.purchased ? '' : 'Pricing Plans',
        appBarAction: isNotShowAction
            ? []
            : [
                if (!value.purchased)
                  TextButton(
                      onPressed: () => _pressedSkip(context),
                      child: Text(
                        'Skip',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ))
              ],
        showLeading: false,
        child: value.purchased
            ? PremiumPlanScreen(tiers: value.tiers?.firstOrNull)
            : SomosListViewBuilder(
                padding: EdgeInsets.only(top: 32.h),
                separationWidget: Gap(24.h),
                withExpanded: false,
                itemBuilder: (updatedTier) => _itemBuilder(
                    value.tiers ?? [], updatedTier, context, isNotShowAction),
                items: value.tiers ?? [],
              ),
      ),
      error: (_, __) => Center(
          child: Text('No Product Found', style: context.textTheme.bodyLarge)),
      loading: () => loadingIndicator,
    );
  }

  _itemBuilder(List<Tiers> tierList, Tiers tierData, BuildContext context,
      bool isHomePage) {
    int index = tierList.indexOf(tierData);

    return PricingPlanWidget(
      tierModel: tierData,
      isHomePage: isHomePage,
      planColorModel: generateRandomColor(PlanColorModel.planModelData, index),
    );
  }

  void _pressedSkip(BuildContext context) {
    storage.setPlanScreenRead(true);
    context.go(DashBoardScreen.routeName);
  }
}

class PricingPlanWidget extends ConsumerWidget {
  const PricingPlanWidget(
      {super.key,
      required this.tierModel,
      required this.planColorModel,
      this.isHomePage = false});

  final Tiers tierModel;
  final bool isHomePage;
  final PlanColorModel planColorModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SomosContainer(
      padding: const EdgeInsets.all(22).r,
      border: planColorModel.gradientBorder,
      borderRadius: AppWidgets.borderRadius,
      child: Column(
        children: [
          Text(
            tierModel.type ?? '',
            style: context.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Gap(24.h),
          Text(
            tierModel.amount ?? '',
            textAlign: TextAlign.center,
            style: context.textTheme.displayLarge?.copyWith(
                color: planColorModel.textColor,
                fontWeight: FontWeight.w700,
                fontSize: 42.sp),
          ),
          Gap(24.h),
          Text(
            tierModel.description ??
                'Receives a minimum of 70% of the monthly membership in crypto monthly',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge,
          ),
          Gap(16.h),
          SomosElevatedButton(
            title: 'Buy Now',
            onPressed: (ctx) =>
                _onBuyNowPressed(ctx, ref, tierModel, isHomePage),
          ),
        ],
      ),
    );
  }

  Future<void> _onBuyNowPressed(BuildContext context, WidgetRef ref,
      Tiers tierModel, bool isHomePage) async {
    try {
      final response = await homeRepository.stripeCreateCustomer(
          StripeCustomerRequest(tierId: tierModel.tierId ?? ''));
      final isSuccess = await PaymentController.initPayment(response.body);
      if (isSuccess) {
        if (isHomePage == false) {
          storage.setPlanScreenRead(true);
          context.go(DashBoardScreen.routeName);
          return;
        }
        ref.read(popShowStateProvider.notifier).state = false;
        await Future.delayed(const Duration(seconds: 2),
            () => ref.invalidate(tierStateProvider));
      }
    } on ApiError catch (e) {
      Utils.displayToast(e.message);
    }
  }
}

String formatAmount(String amountString) {
  double amount = double.parse(amountString);
  String formattedAmount = amount.toStringAsFixed(2);
  return formattedAmount;
}

class PlanColorModel {
  final BoxBorder gradientBorder;
  final Color textColor;

  PlanColorModel({required this.gradientBorder, required this.textColor});
  static List<PlanColorModel> planModelData = [
    PlanColorModel(
      gradientBorder: const GradientBoxBorder(
        gradient: LinearGradient(
          colors: [
            Color(0xff448BFB), // 100%
            Color(0x20448BFB), // 15
          ],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
      ),
      textColor: const Color(0xff448BFB), // Example text color
    ),
    PlanColorModel(
      gradientBorder: const GradientBoxBorder(
        gradient: LinearGradient(
          colors: [
            Color(0xffD16706), // 100%
            Color(0x20D16706), // 15
          ],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
      ),
      textColor: const Color(0xffD16706), // Example text color
    ),
    PlanColorModel(
      gradientBorder: const GradientBoxBorder(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor, // 100%
            Color(0x206552FE), // 15
          ],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
      ),
      textColor: AppColors.primaryColor, // Example text color
    ),
  ];
}

class PremiumPlanScreen extends StatelessWidget {
  final Tiers? tiers;
  const PremiumPlanScreen({super.key, this.tiers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SomosContainer(
          alignment: Alignment.center,
          color: Colors.white,
          shape: BoxShape.circle,
          width: 95.w,
          height: 95.h,
          child: SvgPicture.asset(
            Assets.icons.successTier,
            fit: BoxFit.contain,
          ),
        ),
        Gap(6.h),
        Text(tiers?.type ?? 'Gold Plan',
            style: context.textTheme.headlineLarge?.copyWith(fontSize: 40.sp)),
        Gap(24.h),
        SomosContainer(
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.all(15).r,
          border: const GradientBoxBorder(gradient: AppColors.buttonGradient),
          child: const Column(
            children: [
              Text(
                  'Your premium plan will be Renew on August ,22 ,2024, 5:30 Pm',
                  textAlign: TextAlign.center)
            ],
          ),
        )
      ],
    );
  }
}
