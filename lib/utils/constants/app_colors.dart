import 'package:flutter/material.dart';

import '../../all_utills.dart';

class AppColors {
  static const Color errorColor = Colors.red;

  const AppColors._();

  static const Color primaryColor = Color(0xFF6552FE);
  static const Color homeDropDownColor = Color(0x80353535);
  static const Color textColor = Color(0xffF3F3F3);
  static const Color textPlaceHolderColor = Color(0xFFD9D9D9);
  static const Color hintStyle = Color(0xFF787878);
  static const Color backButtonColor = Color(0x1A787878);
  static const Color backgroundColor = Color(0xff0B0A0A);
  static const Color textButtonColor = Color(0xff6552FE);
  static const Color greenColor = Color(0xff7CFF01);
  static const Color bottomSheetColor = Color(0x80F3F3F3);
  static const Gradient buttonGradient = SweepGradient(
    colors: [
      Color(0xff6552FE),
      Color(0xff01FFF4),
    ],
    center: Alignment.bottomRight,
  );
}
