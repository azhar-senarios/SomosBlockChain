import 'dart:ui';

import 'package:somos_app/all_utills.dart';

class ChoosePlanDialogWidget extends ConsumerWidget {
  const ChoosePlanDialogWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tierData = ref.watch(tierStateProvider);
    return tierData.when(
        data: (value) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
              child: Dialog(
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const VerticalSpacing(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        const SizedBox(),
                        const SizedBox(),
                        Text(
                          'Choose Your Plan',
                          style: context.textTheme.displaySmall?.copyWith(
                            fontFamily: 'Bebas',
                          ),
                        ),
                        const SizedBox(),
                        SvgButton(
                            padding: EdgeInsets.only(right: 10.w),
                            imagePath: Assets.icons.cross,
                            onTap: context.pop),
                      ],
                    ),
                    ChoosePlansWidget(data: value)
                  ],
                ),
              ),
            ),
        error: (_, __) => Center(
            child: Text('Error to Fetching PopUp',
                style: context.textTheme.bodyLarge)),
        loading: () => loadingIndicator);
  }
}
