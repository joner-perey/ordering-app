import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lalaco/const.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/cart_items.dart';
import 'package:shimmer/shimmer.dart';

class CartProductCard extends StatelessWidget {
  final CartItems cartItems;

  const CartProductCard({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          elevation: 8,
          shadowColor: Colors.grey.shade300,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Center(
                        child: Hero(
                          tag: cartItems,
                          child: CachedNetworkImage(
                            imageUrl:
                            '$baseUrl/storage/uploads/${cartItems.product.image}',
                            placeholder: (context, url) => Shimmer.fromColors(
                              highlightColor: Colors.white,
                              baseColor: Colors.grey.shade300,
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 20),
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              cartItems.product.name,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    cartItemsController.updateQuantity(
                                        cartItemId: cartItems.id,
                                        newQuantity: cartItems.quantity - 1);
                                    cartItemsController.getCartItems();
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_left_sharp,
                                    size: 32,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    cartItems.quantity.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    cartItemsController.updateQuantity(
                                        cartItemId: cartItems.id,
                                        newQuantity: cartItems.quantity + 1);
                                    cartItemsController.getCartItems();
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_right_sharp,
                                    size: 32,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -5,
                right: -5,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 28,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Confirm Delete'),
                          content: const Text(
                              'Are you sure you want to delete this item from your cart?'),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                cartItemsController
                                    .deleteCartItem(cartItems.id);
                                cartItemsController.getCartItems();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
