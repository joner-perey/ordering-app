import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lalaco/controller/auth_controller.dart';
import 'package:lalaco/controller/cart_items_controller.dart';
import 'package:lalaco/controller/category_controller.dart';
import 'package:lalaco/controller/dashboard_controller.dart';
import 'package:lalaco/controller/home_controller.dart';
import 'package:lalaco/controller/order_controller.dart';
import 'package:lalaco/controller/product_controller.dart';
import 'package:lalaco/controller/store_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(HomeController());
    Get.put(ProductController());
    Get.put(AuthController());
    Get.put(CategoryController());
    Get.put(StoreController());
    Get.put(CartItemsController());
    Get.put(OrderController());
  }
}