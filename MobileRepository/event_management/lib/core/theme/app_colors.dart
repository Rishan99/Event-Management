import 'package:flutter/material.dart';

//Private Constructor to restrict creating instance of class
class AppColors {
  AppColors._();
  static const Color primaryColor = Color(0xFF8D2B29);
  static const Color secondaryColor = Color(0xFFCD9510);
  static MaterialColor primaryMaterialColor = MaterialColor(primaryColor.value, const {
    50: primaryColor,
    100: primaryColor,
    200: primaryColor,
    300: primaryColor,
    400: primaryColor,
    500: primaryColor,
    600: primaryColor,
    700: primaryColor,
    800: primaryColor,
    900: primaryColor,
  });

  static const Color blackColor = Colors.black;
  static final Color hintColor = Colors.grey.shade600;
  static const Color dividerColor = Colors.grey;
  static final errorColor = Colors.red[800]!;
  static final greenColor = Colors.green[600]!;
  static const Color kColorBackground = Color(0xFFF5F5F5);
  static const Color fillColor = Color(0xfffefefe);
  static const Color buttonColor = primaryColor;
}
