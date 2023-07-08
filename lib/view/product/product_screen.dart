import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lalaco/component/main_header.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/view/product/add_product_screen.dart';
import 'package:lalaco/view/product/components/product_grid.dart';
import 'package:lalaco/view/product/components/product_loading_grid.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              const MainHeader(),
              Expanded(
                child: Obx(() {
                  if (productController.isProductLoading.value) {
                    return const ProductLoadingGrid();
                  } else {
                    if (productController.productList.isNotEmpty) {
                      return ProductGrid(
                          products: productController.productList);
                    } else {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset('assets/product_not_found.png'),
                          SizedBox(height: 10),
                          Text('Products Not Found!')
                        ],
                      );
                    }
                  }
                }),
              ),
            ],
          ),
          Obx(() {
            return authController.user.value?.user_type.toString() == 'Vendor'
                ? Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: FloatingActionButton(
                      heroTag: 'addButton',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddProductScreen()),
                        );
                      },
                      child: Icon(Icons.add),
                      backgroundColor: const Color(0xffff8900),
                    ),
                  )
                : SizedBox(); // Return an empty SizedBox if user.value is null
          }),
        ],
      ),
    );
  }
}
