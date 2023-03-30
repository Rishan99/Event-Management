import 'package:event_management/core/theme/app_colors.dart';
import 'package:event_management/main.dart';
import 'package:flutter/material.dart';

const EdgeInsets pageSidePadding = EdgeInsets.symmetric(horizontal: 14);

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

Widget formSeperatorBox() => const SizedBox(
      height: 15,
    );
showFlexibleBottomSheet(BuildContext context, String title, Widget body, {bool isScrollable = false}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollable,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      )),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: pageSidePadding.left),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(right: pageSidePadding.right),
                child: body,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      });
}
