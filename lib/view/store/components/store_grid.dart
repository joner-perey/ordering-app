import 'package:flutter/material.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/view/product/components/product_card.dart';
import 'package:lalaco/view/store/components/store_card.dart';

class StoreGrid extends StatelessWidget {
  final List<Store> stores;
  const StoreGrid({Key? key, required this.stores}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 2/3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
      ),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(10),
      itemCount: stores.length,
      itemBuilder: (context, index) => StoreCard(store: stores[index]),
    );
  }
}