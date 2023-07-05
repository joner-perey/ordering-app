import 'package:flutter/material.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/view/home/components/popular_store/popular_store_card.dart';

class PopularStore extends StatelessWidget {
  final List<Store> stores;

  const PopularStore({Key? key, required this.stores}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.only(right: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: stores.length,
          itemBuilder: (context, index) =>
              PopularStoreCard(store: stores[index])),
    );
  }
}
