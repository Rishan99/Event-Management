import 'dart:io';

import 'package:event_management/core/constant/app_images.dart';
import 'package:event_management/core/utils/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  const ImageWidget({
    Key? key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((imageUrl ?? '').isNetworkFile()) {
      return Image.network(
        imageUrl!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        gaplessPlayback: true,
        errorBuilder: (a, b, c) => Image.asset(
          AppImage.placeHolder,
          height: height,
          width: width,
          fit: fit ?? BoxFit.contain,
        ),
        loadingBuilder: (z, b, c) => c == null
            ? b
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
    }
    return Image.asset(
      (imageUrl ?? '').isEmpty ? AppImage.placeHolder : imageUrl!,
      height: height,
      fit: fit ?? BoxFit.contain,
      // color: color,
      width: width,
    );
  }
}
