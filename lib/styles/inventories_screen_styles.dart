import 'package:flutter/material.dart';
import '../misc/app_colors.dart';

class InventoriesScreenStyles {
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