import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lalaco/component/main_header.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/view/product/add_product_screen.dart';
import 'package:lalaco/view/product/components/product_grid.dart';
import 'package:lalaco/view/product/components/product_loading_grid.dart';
import 'package:lalaco/view/store/components/store_grid.dart';
import 'package:lalaco/view/store/components/store_loading_grid.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key}) : super(key: key);

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
                  if (storeController.isStoreLoading.value) {
                    return const StoreLoadingGrid();
                  } else {
                    if (storeController.storeList.isNotEmpty) {
                      return StoreGrid(
                          stores: storeController.storeList);
                    } else {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset('assets/product_not_found.png'),
                          SizedBox(height: 10),
                          Text('Stores Not Found!')
                        ],
                      );
                    }
                  }
                }),
              ),
            ],
          ),
          Positioned(
            bottom: 16.0, // Adjust the position as per your requirement
            right: 16.0, // Adjust the position as per your requirement
            child: FloatingActionButton(
              heroTag: 'addButton',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddProductScreen()));
              },
              child: Icon(Icons.add),
              backgroundColor:
              const Color(0xffff8900), // Set your desired color here
            ),
          ),
        ],
      ),
    );
  }
}
