import 'package:carousel_slider/carousel_slider.dart';
import 'package:event_management/app/widgets/image_widget.dart';
import 'package:event_management/core/constant/app_images.dart';
import 'package:event_management/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imageList;
  final int currentIndex;
  final BoxFit boxFit;

  const ImageSlider({
    Key? key,
    required this.imageList,
    this.boxFit = BoxFit.cover,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  List<String> imageList = [];
  @override
  void initState() {
    super.initState();
    imageList = widget.imageList;
    currentIndex.value = widget.currentIndex;
  }

  int get imageListLength => imageList.length;
  @override
  Widget build(BuildContext context) {
    if (imageList.isEmpty) {
      return Image.asset(
        AppImage.placeHolder,
        fit: BoxFit.fill,
        height: double.maxFinite,
        width: double.maxFinite,
      );
    }

    return Stack(
      children: [
        CarouselSlider(
          items: imageList
              .map((e) => ImageWidget(
                    imageUrl: e,
                    fit: widget.boxFit,
                    height: double.maxFinite,
                    width: double.maxFinite,
                  ))
              .toList(),
          carouselController: CarouselController(),
          options: CarouselOptions(
            enableInfiniteScroll: false,
            autoPlay: widget.imageList.length > 1,
            height: double.maxFinite,
            autoPlayInterval: const Duration(seconds: 5),
            scrollPhysics: (imageList.length > 1) ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
            viewportFraction: 1,
            initialPage: currentIndex.value,
            onPageChanged: (index, reason) {
              currentIndex.value = index;
            },
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: currentIndex,
              builder: (context, value, child) {
                return Text(
                  '${value + 1}/$imageListLength',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
