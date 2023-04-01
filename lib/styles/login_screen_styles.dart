import 'package:flutter/material.dart';
import '../misc/app_colors.dart';

class LoginScreenStyles {
  static const ButtonStyle forgotPasswordButtonStyle = ButtonStyle(
    splashFactory: NoSplash.splashFactory,
    backgroundColor: MaterialStatePropertyAll(Colors.transparent),
    padding: MaterialStatePropertyAll(EdgeInsets.zero),
    elevation: MaterialStatePropertyAll(0),
  );

  // forgotPassword styles
  static const TextStyle forgotPasswordStyles = TextStyle(
    color: AppColors.baseBlackColor,
    fontSize: 14,
    decoration: TextDecoration.underline
  );
  // signingSocialStyles
  static const TextStyle signInSocialStyles = TextStyle(
    color: AppColors.baseBlackColor,
  );
  // signupButtonTextStyles
  static const TextStyle signUpButtonTextStyles = TextStyle(
    color: AppColors.baseBlackColor,
    fontSize: 20,
  );

  // signupButtonTextStyles
  static const TextStyle mainHeadingTextStyles = TextStyle(
    color: AppColors.baseWhite60Color,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    fontFamily: "Poppins"
  );
}