import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/order_detail.dart';

class RemoteOrderDetailService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/order_details';

  Future<dynamic> fetchOrderDetails({required int order_id}) async {
    var response =
        await http.get(Uri.parse('$remoteUrl/order/?order_id=$order_id'));
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['order_details'];

    List<OrderDetail> orderDetails = [];
    if (response.statusCode == 200) {
      for (final result in results) {
        orderDetails.add(OrderDetail.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Orders');
    }
    return orderDetails;
  }
}
