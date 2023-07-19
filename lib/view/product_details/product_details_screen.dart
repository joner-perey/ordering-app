import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/view/account/auth/sign_in_screen.dart';
import 'package:lalaco/view/product/components/update_product_screen.dart';
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Visibility(
          visible: authController.user.value != null,
          child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              // Rest of your button logic...
            },
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Text(
                authController.user.value?.user_type == 'Customer'
                    ? 'Add to Cart'
                    : 'Update Product',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
