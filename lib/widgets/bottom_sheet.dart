import 'dart:ui';

import '../all_utills.dart';

void showModelBottomSheet<T>(
  BuildContext context, {
  bool? showDragHandle,
  Widget? child,
  int gap = 10,
  bool customBottomSheet = false,
  double? height,
  Color? background,
  bool isScrolled = true,
  final String title = 'Select a network',
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: isScrolled,
    elevation: 0,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    showDragHandle: showDragHandle ?? false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: SomosContainer(
          height: height,
          color: const Color(0xffF3F3F3).withOpacity(0.5),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: customBottomSheet
              ? child
              : SingleChildScrollView(
                  physics:
                      isScrolled ? null : const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _buildDragHandle(context),
                      // CancelBottomSheetWidget(title: title),
                      Gap(gap.h),
                      child ?? const SizedBox(),
                    ],
                  ),
                ),
        ),
      );
    },
  );
}

Widget _buildDragHandle(BuildContext context) {
  return SomosContainer(
    width: 95.w,
    height: 4.h,
    borderRadius: BorderRadius.circular(4),
    margin: EdgeInsets.symmetric(vertical: 20.h),
    color: const Color(0xFFF6FAFE),
  );
}

class CancelBottomSheetWidget extends StatelessWidget {
  final String title;

  const CancelBottomSheetWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: context.textTheme.bodyLarge),
        SvgButton(
          imagePath: Assets.icons.cross,
          fit: BoxFit.contain,
          width: 20.w,
          height: 20.h,
          onTap: () => onCancelPressed(context),
        ),
      ],
    );
  }

  onCancelPressed(BuildContext context) {
    context.pop();
  }
}
