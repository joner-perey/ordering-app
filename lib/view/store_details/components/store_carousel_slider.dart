import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lalaco/const.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';
import 'package:shimmer/shimmer.dart';

class StoreCarouselSlider extends StatefulWidget {
  final Store store;

  const StoreCarouselSlider({Key? key, required this.store})
      : super(key: key);

  @override
  State<StoreCarouselSlider> createState() => _StoreCarouselSliderState();
}

class _StoreCarouselSliderState extends State<StoreCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseUrl/storage/uploads/${widget.store.image}',
          // imageBuilder: (context, imageProvider) => Container(
          //   decoration: BoxDecoration(
          //       color: Colors.white,
          //       image: DecorationImage(image: imageProvider)),
          // ),
          placeholder: (context, url) => Shimmer.fromColors(
            highlightColor: Colors.white,
            baseColor: Colors.grey.shade300,
            child: Container(
              color: Colors.grey.shade300,
            ),
          ),
          errorWidget: (context, url, error) => const Center(
            child: Icon(
              Icons.error_outline,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
