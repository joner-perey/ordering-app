import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/service/remote_service/remote_product_service.dart';
import 'package:lalaco/service/remote_service/remote_store_service.dart';

import '../service/local_service/local_auth_service.dart';
import 'controllers.dart';

class StoreController extends GetxController {
  static StoreController instance = Get.find();
  RxList<Store> storeList = List<Store>.empty(growable: true).obs;
  RxBool isStoreLoading = false.obs;

  TextEditingController searchTextEditController = TextEditingController();
  RxString searchVal = ''.obs;

  final LocalAuthService localAuthService = LocalAuthService();

  @override
  void onInit() async {
    await localAuthService.init();
    getStores(userId: localAuthService.getUserId().toString());
    super.onInit();
  }

  Future<void> getStores({ required String userId }) async {
    try {
      isStoreLoading(true);
      //call api
      var result = await RemoteStoreService().fetchStores(userId: userId);
      if (result != null) {
        //assign api result
        storeList.assignAll(result);
      }
    } finally {
      isStoreLoading(false);
    }
  }

  Future<Store?> getStoreById({required int storeId, required int userId}) async {
    try {
      isStoreLoading(true);
      //call api
      var result =
      await RemoteStoreService().fetchStoreById(storeId: storeId, userId: userId);
      if (result != null) {
        return result;
      }
    } finally {
      isStoreLoading(false);
    }
  }

  Future<Store?> getStoreByUserId({required int user_id}) async {
    try {
      isStoreLoading(true);
      //call api
      var result =
          await RemoteStoreService().fetchStoreByUserId(user_id: user_id);
      if (result != null) {
        return result;
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

  Future<void> updateStore({
    required int id,
    required String store_name,
    required File? image,
    required String store_description,
    required String location_description,
    required String longitude,
    required String latitude,
  }) async {
    try {
      EasyLoading.show(status: 'Updating...', dismissOnTap: false);
      var result = await RemoteStoreService().updateStore(
        id: id,
        store_name: store_name,
        image: image,
        store_description: store_description,
        location_description: location_description,
        longitude: longitude,
        latitude: latitude,
      );
      if (result.statusCode == 200) {
        // Profile updated successfully
        EasyLoading.showSuccess('Store updated successfully');

        // Optionally, you can update the user object with the updated profile data
        // user.value?.name = name;
        // user.value?.email = email;
        // user.value?.phone_number = phone_number;
      } else {
        // Profile update failed
        EasyLoading.showError('Profile update failed');
      }
    } catch (e) {
      // Error occurred during profile update
      EasyLoading.showError('Profile update failed');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void deleteStore(int store_id) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteStoreService().deleteStore(store_id);
      print(result.statusCode);
      if (result.statusCode == 200) {
        EasyLoading.showSuccess("Store Deleted Successfully!");
        // getProducts();
        deleteStoresInLists(store_id);
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

  void deleteStoresInLists(int store_id) {
    for (int i = 0; i < storeList.length; i++) {
      if (storeList[i].id == store_id) {
        storeList.removeAt(i);
        break;
      }
    }

    // for (int i = 0; i < productPerStoreList.length; i++) {
    //   if (productPerStoreList[i].id == product_id) {
    //     productPerStoreList.removeAt(i);
    //   }
    // }

    for (int i = 0; i < homeController.popularStoreList.length; i++) {
      if (homeController.popularStoreList[i].id == store_id) {
        homeController.popularStoreList.removeAt(i);
      }
    }
  }
}
