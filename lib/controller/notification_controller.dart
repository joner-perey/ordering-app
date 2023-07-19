import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lalaco/model/category.dart';
import 'package:lalaco/model/notification.dart';
import 'package:lalaco/service/remote_service/remote_category_service.dart';
import 'package:lalaco/service/remote_service/remote_notification_service.dart';
import 'package:lalaco/service/remote_service/remote_product_service.dart';

class NotificationController extends GetxController {
  static NotificationController instance = Get.find();

  RxList<NotificationModel> notificationList = List<NotificationModel>.empty(growable: true).obs;
  RxBool isNotificationLoading = false.obs;
  RxInt notificationCount = 0.obs;


  Future<void> getNotifications({required String token}) async {
    try {
      isNotificationLoading(true);
      //call api
      var result = await RemoteNotificationService().fetchNotifications(token: token);
      if (result != null) {
        //assign api result
        notificationList.assignAll(result);
      }
    } finally {
      countUnreadNotification();
      isNotificationLoading(false);
    }
  }

  void countUnreadNotification() {
    int count = 0;

    for (var notif in notificationList) {
      if (notif.read_at == null) {
        count++;
      }
    }

    notificationCount.value = count;
  }

  Future<void> readNotifications({required String token}) async {
      await RemoteNotificationService().readNotifications(token: token);
  }


}