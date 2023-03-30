import 'package:event_management/core/constant/constant.dart';
import 'package:event_management/core/utils/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  const CustomErrorWidget({
    Key? key,
    this.message = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImage.error,
            height: 200,
            width: 200,
          ),
          formSeperatorBox(),
          Text(
            message,
            maxLines: 2,
            style: TextStyle(fontSize: 15, color: Theme.of(context).hintColor, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
