import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DateWidget extends StatelessWidget {
  final String title;
  final String content;
  final bool alignEnd;
  const DateWidget({
    Key? key,
    required this.title,
    required this.content,
    this.alignEnd = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          content,
        )
      ],
    );
  }
}
