import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/order.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/service/remote_service/remote_order_service.dart';
import 'package:lalaco/service/remote_service/remote_product_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OrderController extends GetxController {
  static OrderController instance = Get.find();
  RxList<Order> orderList = List<Order>.empty(growable: true).obs;
  RxBool isOrderLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<dynamic> fetchOrderToCustomer({required String user_id}) async {
    try {
      isOrderLoading(true);
      //call api
      var result =
          await RemoteOrderService().fetchCustomerOrders(user_id: user_id);
      if (result != null) {
        //assign api result
        orderList.assignAll(result);
      }
    } finally {
      isOrderLoading(false);
    }
  }


  Future<dynamic> fetchOrderToVendor({required String store_id}) async {
    try {
      isOrderLoading(true);
      //call api
      var result =
      await RemoteOrderService().fetchVendorOrders(store_id: store_id);
      if (result != null) {
        //assign api result
        orderList.assignAll(result);
      }
    } finally {
      isOrderLoading(false);
    }
  }

  void addOrder({
    required String user_id,
    required String store_id,
    required String address,
    required String phone_number,
    required String longitude,
    required String latitude,
    required String type,
    required String status,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteOrderService().addOrder(
        user_id: user_id,
        store_id: store_id,
        address: address,
        phone_number: phone_number,
        longitude: longitude,
        latitude: latitude,
        type: type,
        status: status,
      );
      if (result.statusCode == 201 || result.statusCode == 200) {
        EasyLoading.showSuccess("Order Completed");
        Navigator.of(Get.overlayContext!).pop();
        cartItemsController.getCartItems();
      } else {
        EasyLoading.showError('1!');
      }
    } catch (e) {
      EasyLoading.showError('2!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateOrderStatus({
    required int id,
    required String status,
  }) async {
    try {
      EasyLoading.show(status: 'Updating...', dismissOnTap: false);
      var result = await RemoteOrderService().updateOrderStatus(
        id: id,
        status: status,
      );
      print(result.body);
      if (result.statusCode == 200) {
        // Profile updated successfully
        EasyLoading.showSuccess('Order status updated successfully');
      } else {
        // Profile update failed
        EasyLoading.showError('1 Order status update failed');
      }
    } catch (e) {
      // Error occurred during profile update
      EasyLoading.showError('2 Order status update failed');
    } finally {
      EasyLoading.dismiss();
    }
  }

}
