import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lalaco/component/main_header.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/view/home/components/popular_product/popular_product.dart';
import 'package:lalaco/view/home/components/popular_product/popular_product_loading.dart';
import 'package:lalaco/view/home/components/popular_store/popular_category_loading.dart';
import 'package:lalaco/view/home/components/popular_store/popular_store.dart';
import 'package:lalaco/view/home/components/section_title.dart';

import 'package:lalaco/view/home/components/carousel_slider/carousel_slider_view.dart';
import 'package:lalaco/view/home/components/carousel_slider/carousel_loading.dart';
import 'package:lalaco/view/product/components/product_grid.dart';
import 'package:lalaco/view/product/product_screen.dart';
import 'package:lalaco/view/store/store_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        const MainHeader(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Obx(() {
                  if (homeController.adBannerList.isNotEmpty) {
                    return CarouselSliderView(
                        bannerList: homeController.adBannerList);
                  } else {
                    return const CarouselLoading();
                  }
                }),
                const SectionTitle(
                  title: "Products",
                  page: ProductScreen(),
                ),
                Obx(() {
                  if (homeController.popularProductList.isNotEmpty) {
                    return PopularProduct(
                        popularProducts: homeController.popularProductList);
                  } else {
                    return const PopularProductLoading();
                  }
                }),
                const SectionTitle(
                  title: "Stores",
                  page: StoreScreen(),
                ),
                Obx(() {
                  if (homeController.popularStoreList.isNotEmpty) {
                    return PopularStore(
                        stores: homeController.popularStoreList);
                  } else {
                    return const PopularStoreLoading();
                  }
                }),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
