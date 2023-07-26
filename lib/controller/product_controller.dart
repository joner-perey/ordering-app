import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lalaco/controller/auth_controller.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/service/remote_service/remote_product_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../service/local_service/local_auth_service.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();
  RxList<Product> productList = List<Product>.empty(growable: true).obs;
  RxList<Product> productPerStoreList = List<Product>.empty(growable: true).obs;
  RxBool isProductLoading = false.obs;

  TextEditingController searchTextEditController = TextEditingController();
  RxString searchVal = ''.obs;

  final LocalAuthService localAuthService = LocalAuthService();

  @override
  void onInit() async {
    authController.onInit();

    await localAuthService.init();
    // productList.clear();
    // productPerStoreList.clear();

    // Timer(Duration(seconds: 3), () async {
    //   getProducts();
    // });

    getProducts();

    // getProductsPerStore(store_id: 1);
    super.onInit();
  }

  void getProducts() async {
    try {
      isProductLoading(true);
      //call api
      var result = await RemoteProductService().fetchProducts(userId: authController.localAuthService.getUserId().toString());
      if (result != null) {
        //assign api result
        productList.assignAll(result);
      }
    } finally {
      isProductLoading(false);
    }
  }

  void getProductByName({required String keyword}) async {
    try {
      isProductLoading(true);
      //call api
      var result = await RemoteProductService().getByName(keyword: keyword);
      if (result != null) {
        productList.assignAll(result);
      }
    } finally {
      isProductLoading(false);
    }
  }

  Future<Product> getProductById({required int id}) async {
    try {
      isProductLoading(true);
      // Call API
      var result = await RemoteProductService().getById(id: id);
      return result; // Return the product
    } finally {
      isProductLoading(false);
    }
  }

  Future<dynamic> getProductsPerStore({required int store_id}) async {
    try {
      isProductLoading(true);
      var result =
          await RemoteProductService().getProductsPerStore(store_id: store_id);
      if (result != null) {
        productPerStoreList.assignAll(result);
      }
      return result;
    } finally {
      isProductLoading(false);
    }
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required int category_id,
    required int store_id,
    required File? image,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteProductService().addProduct(
          name: name,
          description: description,
          price: price,
          category_id: category_id,
          store_id: store_id,
          image: image);
      if (result.statusCode == 201 || result.statusCode == 200) {
        EasyLoading.showSuccess("Product Added!");
        Navigator.of(Get.overlayContext!).pop();
      } else {
        EasyLoading.showError('1!');
      }
    } catch (e) {
      EasyLoading.showError('2!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required String description,
    required double price,
    required int category_id,
    required File? image,
  }) async {
    try {
      EasyLoading.show(status: 'Updating...', dismissOnTap: false);
      print('asd');
      var result = await RemoteProductService().updateProduct(
        id: id,
        name: name,
        description: description,
        price: price,
        category_id: category_id,
        image: image,
      );
      if (result.statusCode == 200) {
        // Profile updated successfully
        EasyLoading.showSuccess('Product updated successfully');
        getProducts();
        getProductsPerStore(store_id: authController.store.value!.id);
        // Optionally, you can update the user object with the updated profile data
        // user.value?.name = name;
        // user.value?.email = email;
        // user.value?.phone_number = phone_number;
      } else {
        // Profile update failed
        EasyLoading.showError('1Product update failed');
      }
    } catch (e) {
      // Error occurred during profile update
      EasyLoading.showError('2Product update failed');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void deleteProduct(int product_id) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteProductService().deleteProduct(product_id);
      print(result.statusCode);
      if (result.statusCode == 200) {
        EasyLoading.showSuccess("Item Deleted Successfully!");
        getProducts();
        deleteProductInLists(product_id);
      } else {
        EasyLoading.showError('Something went wrong. Try again!');
      }
    } catch (e) {
      // print(e);
      EasyLoading.showError('Something went wrong. Try again!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void deleteProductInLists(int product_id) {
    for (int i = 0; i < productList.length; i++) {
      if (productList[i].id == product_id) {
        productList.removeAt(i);
        break;
      }
    }

    for (int i = 0; i < productPerStoreList.length; i++) {
      if (productPerStoreList[i].id == product_id) {
        productPerStoreList.removeAt(i);
      }
    }

    for (int i = 0; i < homeController.popularProductList.length; i++) {
      if (homeController.popularProductList[i].id == product_id) {
        homeController.popularProductList.removeAt(i);
      }
    }
  }
}
