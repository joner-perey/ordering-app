import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lalaco/model/category.dart';
import 'package:lalaco/service/remote_service/remote_category_service.dart';
import 'package:lalaco/service/remote_service/remote_product_service.dart';

class CategoryController extends GetxController {
  static CategoryController instance = Get.find();
  RxList<Category> categoryList = List<Category>.empty(growable: true).obs;
  RxBool isCategoryLoading = false.obs;


  @override
  void onInit() {
    getCategories();
    super.onInit();
  }

  void getCategories() async {
    try {
      isCategoryLoading(true);
      //call api
      var result = await RemoteCategoryService().fetchCategories();
      if (result != null) {
        //assign api result
        categoryList.assignAll(result);

      }
    } finally {
      isCategoryLoading(false);
    }
  }


}