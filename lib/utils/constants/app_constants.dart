import 'package:flutter/cupertino.dart';

import '../../all_utills.dart';

typedef FutureBuildContextCallback = Future<void> Function(
    BuildContext context);
typedef BuildContextCallback = void Function(BuildContext context);
typedef TextCallBack = void Function(String? callBack);
typedef BoolCallback = void Function(bool?);

final Widget loadingIndicator = Platform.isIOS
    ? const Center(
        child: CupertinoActivityIndicator(
        color: Colors.white,
      ))
    : const Center(child: CircularProgressIndicator());

void dummyPendingOnPressed() {
  Utils.displayToast('Functionality will be added later...');
}

const double blurValue = 4.0;

PlanColorModel generateRandomColor(List<PlanColorModel> planColors, int index) {
  final int planColorsLength = planColors.length;
  final int adjustedIndex = index % planColorsLength;
  return planColors[adjustedIndex];
}

final List<String> durations = ['1W', '1M', '3M', '1Y'];

DateTime computeEndDate(DateTime startDate, int index) {
  if (index == 0) {
    return startDate.subtract(const Duration(days: 7));
  } else if (index == 1) {
    return startDate.subtract(const Duration(days: 30));
  } else if (index == 2) {
    return startDate.subtract(const Duration(days: 90));
  }

  return startDate.subtract(const Duration(days: 365));
}
