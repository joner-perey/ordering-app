import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/order.dart';

class RemoteOrderService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/orders';

  Future<dynamic> fetchCustomerOrders({required String user_id}) async {
    var response = await http.get(Uri.parse('$remoteUrl/customer/?user_id=$user_id'));
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['orders'];

    List<Order> orders = [];
    if (response.statusCode == 200) {
      for (final result in results) {
        orders.add(Order.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Orders');
    }
    return orders;
  }

  Future<dynamic> addOrder({
    required user_id,
    required store_id,
    required address,
    required phone_number,
    required longitude,
    required latitude,
    required type,
    required status,
  }) async {
    var body = {
      "user_id": user_id,
      "store_id": store_id,
      "address": address,
      "phone_number": phone_number,
      "longitude": longitude,
      "latitude": latitude,
      "type": type,
      "status": status,
    };
    var response = await client.post(
      Uri.parse('$baseUrl/api/orders'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return response;
  }
}
