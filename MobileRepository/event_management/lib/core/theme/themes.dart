import 'package:event_management/core/theme/app_colors.dart';

import 'package:flutter/material.dart';

class Themes {
  static final Themes _themes = Themes._();
  Themes._();
  factory Themes() {
    return _themes;
  }
  //Default Icon Size
  static const double buttonHeight = 45;
  ThemeData theme() {
    return ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.kColorBackground,
        hintColor: AppColors.hintColor,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primaryColor),
        useMaterial3: true,
        listTileTheme: ListTileThemeData(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          selectedColor: Colors.white,
          textColor: Colors.black,
          contentPadding: const EdgeInsets.all(0),
          minLeadingWidth: 0,
        ),
        appBarTheme: appBarTheme,
        chipTheme: const ChipThemeData(
          deleteIconColor: Colors.black,
          labelStyle: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        primarySwatch: AppColors.primaryMaterialColor,
        dividerColor: AppColors.dividerColor,
        textButtonTheme: textButtonTheme(),
        outlinedButtonTheme: outlinedButtonTheme(),
        elevatedButtonTheme: elevatedButtonTheme(),
        inputDecorationTheme: inputDecorationTheme);
  }

  static boderStyle({Color? color}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          style: color == null ? BorderStyle.none : BorderStyle.solid,
          color: color ?? AppColors.secondaryColor,
        ),
      );
  final ButtonStyle _buttonStyle = ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) => Colors.white),
    textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
    shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) => RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        )),
    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => AppColors.buttonColor),
    minimumSize: MaterialStateProperty.resolveWith<Size>(
      (states) => const Size(double.maxFinite, 43),
    ),
  );
  TextButtonThemeData textButtonTheme() => TextButtonThemeData(
        style: _buttonStyle,
      );
  OutlinedButtonThemeData outlinedButtonTheme() => OutlinedButtonThemeData(
          style: _buttonStyle.copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => Colors.transparent),
        side: MaterialStateProperty.resolveWith(
          (states) => const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
      ));
  ElevatedButtonThemeData elevatedButtonTheme() => ElevatedButtonThemeData(style: _buttonStyle);
  final AppBarTheme appBarTheme = const AppBarTheme(
    elevation: 2.0,
    backgroundColor: AppColors.secondaryColor,
    actionsIconTheme: IconThemeData(color: Colors.white),
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: Colors.white,
    ),
  );

  final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    fillColor: const Color(0xffEBEBEB),
    filled: true,
    errorMaxLines: 2,
    labelStyle: TextStyle(color: AppColors.hintColor, fontWeight: FontWeight.w400, fontSize: 13),
    hintStyle: TextStyle(color: AppColors.hintColor, fontWeight: FontWeight.w400, fontSize: 13),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
    errorStyle: TextStyle(color: AppColors.errorColor, fontWeight: FontWeight.w500, fontSize: 13),
    border: boderStyle(),
    focusedBorder: boderStyle(color: AppColors.primaryColor),
    errorBorder: boderStyle(
      color: AppColors.errorColor,
    ),
    focusedErrorBorder: boderStyle(
      color: AppColors.primaryColor,
    ),
    disabledBorder: boderStyle(),
    enabledBorder: boderStyle(),
  );
}
