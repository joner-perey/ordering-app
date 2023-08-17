import 'package:lalaco/model/order_detail.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/model/user.dart';

class Order {
  final int id;
  final String user_id;
  final String store_id;
  final String address;
  final String phone_number;
  final String longitude;
  final String latitude;
  final String type;
  final String status;
  final List<OrderDetail> orderDetails;
  final Store store;
  final User user;
  final bool has_rating;
  final String payment_method;

  const Order({
    required this.id,
    required this.user_id,
    required this.store_id,
    required this.address,
    required this.phone_number,
    required this.longitude,
    required this.latitude,
    required this.type,
    required this.status,
    required this.orderDetails,
    required this.store,
    required this.user,
    required this.has_rating,
    required this.payment_method,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final List<dynamic> orderDetails = json['order_details'];
    final List<OrderDetail> _orderDetails = [];

    for (var orderDetail in orderDetails) {
      final OrderDetail product = OrderDetail.fromJson(orderDetail);
      _orderDetails.add(product);
    }

    final List<OrderDetail> finalProducts = _orderDetails;
    return Order(
      id: json['id'],
      user_id: json['user_id'].toString(),
      store_id: json['store_id'].toString(),
      address: json['address'],
      phone_number: json['phone_number'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      type: json['type'],
      status: json['status'],
      orderDetails: finalProducts,
      store: Store.fromJson(json['store']),
      user: User.fromJson(json['user']),
      has_rating: json['has_rating'],
      payment_method: json['payment_method']
    );
  }
}
