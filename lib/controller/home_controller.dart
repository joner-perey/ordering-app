import 'dart:async';

import 'package:get/get.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/ad_banner.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/service/remote_service/remote_banner_service.dart';
import 'package:lalaco/service/remote_service/remote_category_service.dart';
import 'package:lalaco/service/remote_service/remote_store_service.dart';
import 'package:lalaco/service/remote_service/remote_product_service.dart';

import '../service/local_service/local_auth_service.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  RxList<AdBanner> adBannerList = List<AdBanner>.empty(growable: true).obs;
  RxList<Store> popularStoreList = List<Store>.empty(growable: true).obs;
  RxList<Product> popularProductList = List<Product>.empty(growable: true).obs;
  RxBool isBannerLoading = false.obs;
  RxBool isPopularStoreLoading = false.obs;
  RxBool isPopularProductLoading = false.obs;

  final LocalAuthService localAuthService = LocalAuthService();

  @override
  void onInit() async {
    await localAuthService.init();
    getAdBanners();
    getPopularStores();

    // Timer(Duration(seconds: 3), () async {
    //   getPopularProducts();
    // });

    getPopularProducts();

    super.onInit();
  }

  void getAdBanners() async {
    try {
      isBannerLoading(false);
      //assigning local ad banners before call api

      //call api
      var result = await RemoteBannerService().get();
      if (result != null) {
        //assign api result
        adBannerList.assignAll(result);
      }
    } finally {
      isBannerLoading(false);
    }
  }

  void getPopularStores() async {
    try {
      isPopularStoreLoading(true);
      String userId = localAuthService.getUserId() == null ? '0' : localAuthService.getUserId()!.toString();
      var result = await RemoteStoreService().fetchStores(userId: userId);
      if (result != null) {
        popularStoreList.assignAll(result);
      }
    } finally {
      isPopularStoreLoading(false);
    }
  }

  void getPopularProducts() async {
    try {
      isPopularProductLoading(true);
      var result = await RemoteProductService().fetchProducts(userId: localAuthService.getUserId().toString());
      if (result != null) {
        popularProductList.assignAll(result);
      }
    } finally {
      isPopularProductLoading(false);
    }
  }
}
