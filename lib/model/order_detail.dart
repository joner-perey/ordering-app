import 'package:lalaco/model/product.dart';

class OrderDetail {
  final int id;
  final int order_id;
  final int product_id;
  final int quantity;
  final double price;
  final Product product;

  const OrderDetail({
    required this.id,
    required this.order_id,
    required this.product_id,
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    // final List<dynamic> orderDetails = json['order_details'];
    // final List<Product> products = [];
    // final List<Product> finalProducts = products;
    print('order details');
    return OrderDetail(
      id: json['id'],
      order_id: json['order_id'],
      product_id: json['product_id'],
      quantity: json['quantity'],
      price: double.parse(json['price']),
      product: Product.fromJson(json['product']),
    );
  }
}
