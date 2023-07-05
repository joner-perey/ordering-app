import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/service/remote_service/remote_product_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();
  RxList<Product> productList = List<Product>.empty(growable: true).obs;
  RxList<Product> productPerStoreList = List<Product>.empty(growable: true).obs;
  RxBool isProductLoading = false.obs;

  TextEditingController searchTextEditController = TextEditingController();
  RxString searchVal = ''.obs;

  @override
  void onInit() {
    getProducts();
    // getProductsPerStore(store_id: 1);
    super.onInit();
  }

  void getProducts() async {
    try {
      isProductLoading(true);
      //call api
      var result = await RemoteProductService().fetchProducts();
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
        //assign api result
        // productList.clear();
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
      var result = await RemoteProductService().getProductsPerStore(store_id: store_id);
      if (result != null) {
        productPerStoreList.assignAll(result);
      }

      return result;
    } finally {
      isProductLoading(false);
    }
  }


  void addProduct({
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
        getProducts();
      } else {
        EasyLoading.showError('1!');
      }
    }
    catch (e) {
      EasyLoading.showError('2!');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
