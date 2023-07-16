import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/view/account/auth/sign_in_screen.dart';
import 'package:lalaco/view/product_details/compnents/product_carousel_slider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  NumberFormat formatter = NumberFormat('00');
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            ProductCarouselSlider(product: widget.product),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.product.name,
                style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '\Php${widget.product.price.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: authController.user.value?.user_type == 'Customer',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (_qty > 1) {
                                setState(() {
                                  _qty--;
                                });
                              }
                            },
                            child: Icon(
                              Icons.keyboard_arrow_left_sharp,
                              size: 32,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            formatter.format(_qty),
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade800),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _qty++;
                              });
                            },
                            child: Icon(
                              Icons.keyboard_arrow_right_sharp,
                              size: 32,
                              color: Colors.grey.shade800,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'About this product:',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.product.description,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: authController.user.value?.user_type == 'Customer',
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
            ),
            onPressed: () {
              if (authController.user.value != null) {
                int? lastStoreId = cartItemsController.cartItemList.isNotEmpty
                    ? cartItemsController.cartItemList.last.store_id
                    : null;
                if (lastStoreId == widget.product.store_id ||
                    lastStoreId == null) {
                  cartItemsController.addToCart(
                      product_id: widget.product.id,
                      quantity: _qty,
                      user_id: int.parse(authController.user.value!.id),
                      store_id: widget.product.store_id);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Add to Cart'),
                        content: const Text(
                            'The product you want to add has different store than the current product/s in cart?'),
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
                              'Confirm',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              cartItemsController.addToCart(
                                  product_id: widget.product.id,
                                  quantity: _qty,
                                  user_id:
                                      int.parse(authController.user.value!.id),
                                  store_id: widget.product.store_id);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()));
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Text(
                'Add to Cart',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
