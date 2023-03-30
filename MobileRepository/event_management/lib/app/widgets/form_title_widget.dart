import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FormTitleWidget extends StatelessWidget {
  final String title;
  final Widget child;
  const FormTitleWidget({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 3,
        ),
        child
      ],
    );
  }
}
