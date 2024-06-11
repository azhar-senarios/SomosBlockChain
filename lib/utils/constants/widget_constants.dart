import 'package:flutter/cupertino.dart';

class AppWidgets {
  static const extendBodyBehindAppBar = true;

  static const fullScreenPaddingValue = 24.0;
  static const borderRadiusValue = 16.0;
  static const elevatedButtonHeight = 56.0;

  static const halfBorderRadiusValue = borderRadiusValue / 2.0;

  static const fullScreenHorizontalPaddingValue = fullScreenPaddingValue / 2;

  static const fullScreenVerticalPaddingValue = fullScreenPaddingValue / 2;

  static const fullScreenPadding = EdgeInsets.all(fullScreenPaddingValue);

  static const fullScreenHorizontalPadding =
      EdgeInsets.symmetric(horizontal: fullScreenPaddingValue);

  static const fullScreenVerticalPadding =
      EdgeInsets.all(fullScreenPaddingValue);

  static const verticalGap = SizedBox(height: fullScreenPaddingValue);
  static const halfVerticalGap = SizedBox(height: fullScreenPaddingValue / 2);

  static const horizontalGap = SizedBox(width: fullScreenPaddingValue / 2);
  static const halfHorizontalGap = SizedBox(width: fullScreenPaddingValue);

  static final borderRadius = BorderRadius.circular(borderRadiusValue);

  static final halfBorderRadius =
      BorderRadius.circular(fullScreenPaddingValue / 2);
}
