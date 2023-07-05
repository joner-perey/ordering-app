import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/view/account/auth/sign_in_screen.dart';
import 'package:lalaco/view/cart_items/cart_screen.dart';
import 'package:lalaco/view/product/product_screen.dart';
import 'package:lalaco/view/store/store_screen.dart';

class MainHeader extends StatefulWidget {
  const MainHeader({Key? key}) : super(key: key);

  @override
  _MainHeaderState createState() => _MainHeaderState();
}

class _MainHeaderState extends State<MainHeader> {
  String _selectedFilter = 'Product'; // Default filter type is 'Product'

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 10),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    offset: const Offset(0, 0),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                autofocus: true,
                controller: productController.searchTextEditController,
                onSubmitted: (val) {
                  if (_selectedFilter == 'Product') {
                    productController.getProductByName(
                        keyword: productController.searchVal.value);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductScreen()));
                  } else {
                    storeController.getStoreByName(
                        keyword: storeController.searchVal.value);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StoreScreen()));
                  }
                },
                onChanged: (val) {
                  productController.searchVal.value = val;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  hintText: _selectedFilter == 'Product'
                      ? 'Product name...'
                      : 'Store name...',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.grey.withOpacity(0.6), blurRadius: 8),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  _selectedFilter = value;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Product',
                  child: Text('Filter by Product'),
                ),
                const PopupMenuItem<String>(
                  value: 'Store',
                  child: Text('Filter by Store'),
                ),
              ],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.filter_alt_off_outlined,
                    color: Colors.grey,
                  ),
                  if (_selectedFilter != 'Product')
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedFilter = 'Product';
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              if (authController.user.value != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()));
              }
            },
            child: Obx(() {
              final String cartItemCount = authController.user.value != null
                  ? cartItemsController.cartItemList.length?.toString() ?? ''
                  : '';

              return badges.Badge(
                badgeContent: Text(
                  cartItemCount,
                  style: const TextStyle(color: Colors.white),
                ),
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.grey,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
