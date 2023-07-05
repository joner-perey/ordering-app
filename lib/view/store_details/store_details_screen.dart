import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/view/home/components/popular_product/popular_product.dart';
import 'package:lalaco/view/home/components/popular_product/popular_product_loading.dart';
import 'package:lalaco/view/home/components/section_title.dart';
import 'package:lalaco/view/product/product_screen.dart';
import 'package:lalaco/view/product_details/compnents/product_carousel_slider.dart';
import 'package:lalaco/view/store_details/components/store_carousel_slider.dart';

class StoreDetailsScreen extends StatefulWidget {
  final Store store;

  const StoreDetailsScreen({Key? key, required this.store}) : super(key: key);

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      await productController.getProductsPerStore(store_id: 1);
      setState(() {
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StoreCarouselSlider(store: widget.store),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.store.store_name,
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'About this store:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.store.store_description,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ),
              const SizedBox(height: 10),
              const SectionTitle(
                title: "Store Products",
                page: ProductScreen(),
              ),
              Obx(() {
                if (homeController.popularProductList.isNotEmpty) {
                  return PopularProduct(
                    popularProducts: productController.productPerStoreList,
                    // popularProducts: homeController.popularProductList,
                  );
                } else {
                  return const PopularProductLoading();
                }
              }),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
