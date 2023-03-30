import 'package:event_management/core/theme/app_colors.dart';
import 'package:event_management/main.dart';
import 'package:flutter/material.dart';

failureSnackBar(String message) {
  scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: AppColors.errorColor,
  ));
}

successSnackBar(String message) {
  scaffoldMessengerKey.currentState!.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.greenColor,
    ),
  );
}
