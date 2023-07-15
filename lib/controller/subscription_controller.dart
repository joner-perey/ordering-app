import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/order.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/subscription.dart';
import 'package:lalaco/service/remote_service/remote_order_service.dart';
import 'package:lalaco/service/remote_service/remote_product_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lalaco/service/remote_service/remote_subscription_service.dart';

class SubscriptionController extends GetxController {
  static SubscriptionController instance = Get.find();
  RxList<Subscription> subscriptionList = List<Subscription>.empty(growable: true).obs;
  RxBool isSubscriptionLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchSubscriptions({required int storeId}) async {
    try {
      isSubscriptionLoading(true);
      //call api
      var result =
      await RemoteSubscriptionService().fetchSubscriptions(storeId: storeId);
      if (result != null) {
        //assign api result
        subscriptionList.assignAll(result);
      }
    } finally {
      isSubscriptionLoading(false);
    }
  }

  Future<void> addSubscription({
    required String user_id,
    required String store_id,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteSubscriptionService().addSubscription(
        user_id: user_id,
        store_id: store_id
      );
      if (result.statusCode == 201 || result.statusCode == 200) {
        EasyLoading.showSuccess("Subscribed");
      } else {
        print(result.body);
        EasyLoading.showError('1!');
      }
    } catch (e) {
      EasyLoading.showError('2!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteSubscription({
    required String user_id,
    required String store_id,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteSubscriptionService().deleteSubscription(
          user_id: user_id,
          store_id: store_id
      );
      if (result.statusCode == 201 || result.statusCode == 200) {
        EasyLoading.showSuccess("Unsubscribed");
      } else {
        print(result.body);
        EasyLoading.showError('1!');
      }
    } catch (e) {
      EasyLoading.showError('2!');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
