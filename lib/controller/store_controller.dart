import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/service/remote_service/remote_product_service.dart';
import 'package:lalaco/service/remote_service/remote_store_service.dart';

class StoreController extends GetxController {
  static StoreController instance = Get.find();
  RxList<Store> storeList = List<Store>.empty(growable: true).obs;
  RxBool isStoreLoading = false.obs;

  TextEditingController searchTextEditController = TextEditingController();
  RxString searchVal = ''.obs;

  @override
  void onInit() {
    getStores();
    super.onInit();
  }

  void getStores() async {
    try {
      isStoreLoading(true);
      //call api
      var result = await RemoteStoreService().fetchStores();
      if (result != null) {
        //assign api result
        storeList.assignAll(result);

      }
    } finally {
      isStoreLoading(false);
    }
  }

  void getStoreByName({required String keyword}) async {
    try {
      isStoreLoading(true);
      //call api
      var result = await RemoteStoreService().getByName(keyword: keyword);
      if (result != null) {
        //assign api result
        // productList.clear();
        storeList.assignAll(result);
      }
    } finally {
      isStoreLoading(false);
    }
  }

}