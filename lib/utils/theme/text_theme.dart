import 'package:somos_app/gen/fonts.gen.dart';

import '../../all_utills.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTheme(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .copyWith(
          displayLarge: _buildTextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 54.sp,
            color: AppColors.textColor,
          ),
          displayMedium: _buildTextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 32.sp,
            color: AppColors.textColor,
          ),
          displaySmall: _buildTextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 28.sp,
            color: AppColors.textColor,
          ),
          headlineLarge: _buildTextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 32.sp,
            color: AppColors.textColor,
          ),
          headlineMedium: _buildTextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            color: AppColors.textPlaceHolderColor,
          ),
          headlineSmall: _buildTextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18.sp,
            letterSpacing: 0.5,
            color: AppColors.textPlaceHolderColor,
          ),
          titleLarge: _buildTextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            color: AppColors.textPlaceHolderColor,
          ),
          titleMedium: _buildTextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
            color: AppColors.textColor,
          ),
          titleSmall: _buildTextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: AppColors.textColor,
          ),
          bodyLarge: _buildTextStyle(
            fontSize: 16.sp,
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: _buildTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
          bodySmall: _buildTextStyle(
            fontSize: 12.sp,
            color: AppColors.textColor,
          ),
        )
        .apply(fontSizeFactor: 1.sp);
  }

  static darkTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }

  static TextStyle _buildTextStyle({
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 12.0,
    double letterSpacing = 0,
    Color color = Colors.red,
  }) {
    return TextStyle(
      fontFamily: FontFamily.urbanist,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
