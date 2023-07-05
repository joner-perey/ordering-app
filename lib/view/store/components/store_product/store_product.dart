import 'package:flutter/material.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/view/home/components/popular_product/popular_product_card.dart';
import 'package:lalaco/view/store/components/store_product/store_product_card.dart';


class StoreProduct extends StatelessWidget {
  final List<Store> storeProducts;
  const StoreProduct({Key? key, required this.storeProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.only(right: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: storeProducts.length,
          itemBuilder: (context, index) => StoreProductCard(store: storeProducts[index])),
    );
  }
}