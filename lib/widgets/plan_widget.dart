import '../all_utills.dart';
import '../models/response/get_tier_response.dart';
import '../screens/home/dashboard_screen.dart';

class PlanWidget extends ConsumerWidget {
  const PlanWidget({super.key, required this.plan});

  final Tiers plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SomosContainer(
      color: Colors.black,
      borderRadius: AppWidgets.borderRadius,
      width: 160.w,
      padding: const EdgeInsets.all(12.0),
      onPressed: (_) => _onPressed(_, ref),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            plan.type ?? 'Plan Type',
            style: context.textTheme.headlineMedium?.copyWith(
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gap(16.h),
          RichText(
            text: TextSpan(
              text: '\$${_filterTierAmount()}',
              style: context.textTheme.displayMedium?.copyWith(
                color: context.theme.primaryColor,
              ),
              children: [
                TextSpan(
                  text: '/month',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Gap(16.h),
          Text(
            plan.description ?? 'Plan Description!',
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Gap(16.h),
          InkWell(
            onTap: () {},
            child: SomosContainer(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              borderRadius: AppWidgets.borderRadius,
              border: const GradientBoxBorder(
                gradient: AppColors.buttonGradient,
                // transform = GradientRotation(1.4)
              ),
              child: Text(
                'Buy Now',
                style: context.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _filterTierAmount() {
    return plan.amount!.substring(1, plan.amount!.indexOf('/'));
  }

  void _onPressed(BuildContext context, WidgetRef ref) {
    context.pop();

    ref.read(bottomNavigationIndexProvider.notifier).updateCurrentIndex(1);
  }
}
