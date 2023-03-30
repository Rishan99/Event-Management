import 'package:event_management/core/constant/constant.dart';
import 'package:event_management/core/utils/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NoResultWidget extends StatelessWidget {
  final String message;
  const NoResultWidget({
    Key? key,
    this.message = "No Result Found",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            AppImage.noResult,
            height: 150,
            width: 150,
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
