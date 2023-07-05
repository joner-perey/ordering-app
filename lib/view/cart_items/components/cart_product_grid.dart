import 'package:flutter/material.dart';
import 'package:lalaco/model/cart_items.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/view/cart_items/components/cart_product_card.dart';
import 'package:lalaco/view/product/components/product_card.dart';

class CartProductGrid extends StatelessWidget {
  final List<CartItems> cartItems;
  const CartProductGrid({Key? key, required this.cartItems}) : super(key: key);

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
      itemCount: cartItems.length,
      itemBuilder: (context, index) => CartProductCard(cartItems: cartItems[index]),
    );
  }
}