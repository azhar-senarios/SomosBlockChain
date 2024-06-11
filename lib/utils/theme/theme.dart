import 'package:somos_app/gen/fonts.gen.dart';

import '../../all_utills.dart';
import 'text_theme.dart';

class AppTheme {
  static lightTheme(BuildContext context) {
    const primaryColor = AppColors.primaryColor;

    final textTheme = AppTextTheme.lightTheme(context);

    final buttonTextStyle = MaterialStatePropertyAll(
      textTheme.bodyMedium?.copyWith(
        color: primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );

    final borderRadius = AppWidgets.borderRadius;

    const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
    final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      fixedSize: Size(1.sw, 51.h),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
    return ThemeData(
      fontFamily: FontFamily.urbanist,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          textStyle: buttonTextStyle,
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          foregroundColor: const WidgetStatePropertyAll(primaryColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
      hintColor: AppColors.textPlaceHolderColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light().copyWith(
        onError: const Color(0xffFE0000),
        onTertiary: const Color(0xff7CFF01),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.errorColor),
          borderRadius: borderRadius,
        ),
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.textColor),
          borderRadius: borderRadius,
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.errorColor),
          borderRadius: borderRadius,
        ),
        enabledBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.textPlaceHolderColor),
          borderRadius: borderRadius,
        ),
        border: inputBorder.copyWith(
          borderSide: const BorderSide(
            color: AppColors.textPlaceHolderColor,
            width: 2.0,
          ),
          borderRadius: borderRadius,
        ),
        errorMaxLines: 3,
        errorStyle: textTheme.bodyMedium?.copyWith(color: AppColors.errorColor),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      iconTheme: IconThemeData(color: AppColors.textColor, size: 20.h),
      listTileTheme: ListTileThemeData(
        iconColor: primaryColor,
        textColor: AppColors.textColor,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium,
        contentPadding: EdgeInsets.zero,
      ),
      switchTheme: const SwitchThemeData(
        trackColor: MaterialStatePropertyAll(primaryColor),
        thumbColor: MaterialStatePropertyAll(AppColors.textColor),
      ),
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.transparent,
        unselectedLabelColor: AppColors.textColor,
        labelColor: AppColors.textColor,
        labelStyle: textTheme.bodyLarge,
        unselectedLabelStyle: textTheme.bodyLarge,
        indicatorColor: Colors.transparent,
        labelPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.label,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 1222,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(18, 18, 18, 0.70),
        selectedItemColor: primaryColor,
        unselectedItemColor: AppColors.textColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.textPlaceHolderColor,
        thickness: 0.2,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: AppWidgets.borderRadius,
          ),
          side: const BorderSide(color: AppColors.textColor),
        ),
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: textTheme.titleSmall,
        backgroundColor: const Color.fromRGBO(243, 243, 243, 0.10),
        iconColor: AppColors.textColor,
      ),
      dialogBackgroundColor: const Color.fromRGBO(243, 243, 243, 0.10),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: const Color(0xffF3F3F3).withOpacity(0.5),
        dragHandleColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        dragHandleSize: Size(0.6.sw, 3.h),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.textColor,
        textStyle: textTheme.bodyMedium,
        iconColor: AppColors.textColor,
        position: PopupMenuPosition.under,
        labelTextStyle: MaterialStatePropertyAll(
            textTheme.bodyMedium?.copyWith(color: AppColors.backgroundColor)),
      ),
    );
  }
}
