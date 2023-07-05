import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/cart_items.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/service/remote_service/remote_cart_items_service.dart';
import 'package:lalaco/service/remote_service/remote_product_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CartItemsController extends GetxController {
  static CartItemsController instance = Get.find();
  RxList<CartItems> cartItemList = List<CartItems>.empty(growable: true).obs;
  RxBool isCartItemsLoading = false.obs;

  @override
  void onInit() {
    getCartItems();
    super.onInit();
  }

  void getCartItems() async {
    try {
      isCartItemsLoading(true);
      //call api
      var result = await RemoteCartItemsService().fetchCartItems();
      if (result != null) {
        //assign api result
        cartItemList.assignAll(result);
      }
    } finally {
      isCartItemsLoading(false);
    }
  }

  void addToCart({
    required int product_id,
    required int quantity,
    required int user_id,
    required int store_id,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );

      int? lastStoreId =
          cartItemList.isNotEmpty ? cartItemList.last.store_id : null;
      var result;
      print(lastStoreId);
      print(store_id);
      if (lastStoreId == store_id || lastStoreId == null) {
        result = await RemoteCartItemsService().addToCart(
            product_id: product_id,
            quantity: quantity,
            user_id: user_id,
            store_id: store_id);
        if (result.statusCode == 200) {
          EasyLoading.showSuccess("Successfully Added to Cart!");
          Navigator.of(Get.overlayContext!).pop();
        } else {
          EasyLoading.showError('Something wrong. Try again!');
        }
      } else {
        result = await RemoteCartItemsService()
            .deleteAllCartItems(cartItemList.last.store_id);
        result = await RemoteCartItemsService().addToCart(
            product_id: product_id,
            quantity: quantity,
            user_id: user_id,
            store_id: store_id);
        if (result.statusCode == 200) {
          EasyLoading.showSuccess("Successfully Added to Cart!");
          Navigator.of(Get.overlayContext!).pop();
        } else {
          EasyLoading.showError('Something wrong. Try again!');
        }
      }
      cartItemsController.getCartItems();
    } catch (e) {
      // print(e);
      EasyLoading.showError('Something wrong. Try again!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void updateQuantity({
    required int cartItemId,
    required int newQuantity,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteCartItemsService().updateCartItemQuantity(
        cartItemId: cartItemId,
        newQuantity: newQuantity,
      );
      print(result.statusCode);
      if (result.statusCode == 200) {
        EasyLoading.showSuccess("Quantity Updated Successfully!");
      } else {
        EasyLoading.showError('Something went wrong. Try again!');
      }
      cartItemsController.getCartItems();
    } catch (e) {
      // print(e);
      EasyLoading.showError('Something went wrong. Try again!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void deleteCartItem(int cartItemId) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteCartItemsService().deleteCartItem(cartItemId);
      print(result.statusCode);
      if (result.statusCode == 200) {
        EasyLoading.showSuccess("Item Deleted Successfully!");
      } else {
        EasyLoading.showError('Something went wrong. Try again!');
      }
      cartItemsController.getCartItems();
    } catch (e) {
      // print(e);
      EasyLoading.showError('Something went wrong. Try again!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void deleteAllCartItem(int storeId) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteCartItemsService().deleteAllCartItems(storeId);
      if (result.statusCode == 200) {
        EasyLoading.showSuccess("Items Deleted Successfully!");
      } else {
        EasyLoading.showError('Something went wrong. Try again!');
      }
      cartItemsController.getCartItems();
    } catch (e) {
      // print(e);
      EasyLoading.showError('Something went wrong. Try again!');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
