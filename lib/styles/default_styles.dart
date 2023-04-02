import 'package:flutter/material.dart';

import '../misc/app_colors.dart';

class DefaultStyles {
  static const TextStyle checkBoxTextStyles = TextStyle(
      fontSize: 17,
      fontFamily: "Poppins"
  );

  static const TextStyle defaultTextStyles = TextStyle(
    fontSize: 20,
    fontFamily: "poppins",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h1 = TextStyle(
    color: AppColors.baseBlackColor,
    fontWeight: FontWeight.bold,
    fontFamily: "Nunito",
    fontSize: 24,
  );

  static const TextStyle h2 = TextStyle(
    color: AppColors.baseBlackColor,
    fontWeight: FontWeight.w900,
    fontFamily: "poppins",
    fontSize: 20,
  );

  static const TextStyle noOfResults = TextStyle(
      color: AppColors.baseGrey50Color,
      fontWeight: FontWeight.w600,
      fontFamily: "poppins",
      fontSize: 20,
      decoration: TextDecoration.underline
  );

  static const TextStyle pSmallStylized = TextStyle(
    color: AppColors.baseGrey60Color,
    fontWeight: FontWeight.w600,
    fontFamily: "poppins",
    fontSize: 13,
  );
}