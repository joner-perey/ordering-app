import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lalaco/component/main_header.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/view/cart_items/components/cart_items_loading_grid.dart';
import 'package:lalaco/view/cart_items/components/cart_product_grid.dart';
import 'package:lalaco/view/place_order/place_order_screen.dart';
import 'package:lalaco/view/product/add_product_screen.dart';
import 'package:lalaco/view/product/components/product_grid.dart';
import 'package:lalaco/view/product/components/product_loading_grid.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IconButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   icon: const Icon(Icons.arrow_back),
            // ),
            Expanded(
              child: Obx(() {
                if (cartItemsController.isCartItemsLoading.value) {
                  return const CartItemsLoadingGrid();
                } else {
                  if (cartItemsController.cartItemList.isNotEmpty) {
                    return CartProductGrid(
                      cartItems: cartItemsController.cartItemList,
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/product_not_found.png'),
                        Text('Cart is Empty!',
                            style: TextStyle(
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight.bold)),
                      ],
                    );
                  }
                }
              }),
            ),
            Visibility(
              visible: cartItemsController.cartItemList.isNotEmpty,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if (cartItemsController.cartItemList.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PlaceOrderScreen()));
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: Colors.orange,
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
