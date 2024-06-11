import '../all_utills.dart';
import '../models/response/get_tier_response.dart';

class ChoosePlansWidget extends StatelessWidget {
  final TierSubscriptionModel? data;
  const ChoosePlansWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    if (data?.tiers == null || data?.purchased == true) return const SizedBox();
    final plans = data?.tiers ?? [];
    const angle = pi * 0.15;
    const scale = 0.9;

    const xOffset = 45.0;
    const yOffset = 10.0;

    final gap = Gap(24.h);

    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: plans.length > 2
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                gap,
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _TransformedPlanCardWidget(
                      tier: plans.first,
                      scale: scale,
                      angle: -angle,
                      offset: const Offset(-xOffset, yOffset),
                    ),
                    _TransformedPlanCardWidget(
                      tier: plans.elementAt(1),
                      scale: scale,
                      offset: const Offset(0, -yOffset),
                    ),
                    _TransformedPlanCardWidget(
                      tier: plans.last,
                      scale: scale,
                      angle: angle,
                      offset: const Offset(xOffset, yOffset),
                    ),
                  ],
                ),
                gap,
              ],
            )
          : const SizedBox(),
    );
  }
}

class _TransformedPlanCardWidget extends StatelessWidget {
  const _TransformedPlanCardWidget({
    this.scale = 0.8,
    this.angle = 0,
    required this.tier,
    required this.offset,
  });

  final Tiers tier;
  final Offset offset;
  final double scale;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Transform.scale(
        scale: scale,
        child: Transform.rotate(angle: angle, child: PlanWidget(plan: tier)),
      ),
    );
  }
}
