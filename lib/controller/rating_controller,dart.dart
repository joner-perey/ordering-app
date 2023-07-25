import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/rating.dart';
import 'package:lalaco/service/remote_service/remote_product_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lalaco/service/remote_service/remote_rating_service.dart';

class RatingController extends GetxController {
  static RatingController instance = Get.find();
  RxList<Rating> ratingPerStoreList = List<Rating>.empty(growable: true).obs;
  RxBool isRatingLoading = false.obs;

  TextEditingController searchTextEditController = TextEditingController();
  RxString searchVal = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<Rating>> getRatingByStoreId({required int store_id}) async {
    try {
      isRatingLoading(true);
      var result = await RemoteRatingService().getByStoreId(store_id: store_id);
      if (result != null) {
        ratingPerStoreList.assignAll(result);
      }
      return result;
    } finally {
      isRatingLoading(false);
    }
  }

  Future<double> getAverageRatingByStoreId({required int store_id}) async {
    try {
      isRatingLoading(true);
      double result = await RemoteRatingService()
          .getAverageRatingByStoreId(store_id: store_id);
      print('rating:  $result');
      return result;
    } finally {
      isRatingLoading(false);
    }
  }

  void addRating({
    required int store_id,
    required int user_id,
    required String comment,
    required double rate,
    required int order_id,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteRatingService().addRating(
        store_id: store_id,
        user_id: user_id,
        comment: comment,
        rate: rate,
        order_id: order_id,
      );
      if (result.statusCode == 201 || result.statusCode == 200) {
        EasyLoading.showSuccess("Review Added!");
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
}
