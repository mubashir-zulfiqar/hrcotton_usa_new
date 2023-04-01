import 'package:flutter/material.dart';
import '../misc/app_colors.dart';

class CustomWidgets {

  static void showSnackBar(String message, IconData icon, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: AppColors.baseGrey40Color,
            ),
          ),
          Icon(
            icon,
            color: AppColors.baseGrey40Color,
          )
        ],
      ),
    ));
  }


}
