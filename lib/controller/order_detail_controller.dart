import 'package:get/get.dart';
import 'package:lalaco/model/order_detail.dart';
import 'package:lalaco/service/remote_service/remote_order_detail_service.dart';

class OrderDetailController extends GetxController {
  static OrderDetailController instance = Get.find();
  RxList<OrderDetail> orderDetailList =
      List<OrderDetail>.empty(growable: true).obs;
  RxBool isOrderDetailLoading = false.obs;

  Future<dynamic> fetchOrderToCustomer({required int order_id}) async {
    try {
      isOrderDetailLoading(true);
      //call api
      var result = await RemoteOrderDetailService()
          .fetchOrderDetails(order_id: order_id);
      if (result != null) {
        //assign api result
        orderDetailList.assignAll(result);
      }
    } finally {
      isOrderDetailLoading(false);
    }
  }
}
