import 'package:lalaco/model/product.dart';

class CartItems {
  final int id;
  final int user_id;
  final int product_id;
  final int store_id;
  final int quantity;
  final Product product;

  const CartItems({
    required this.id,
    required this.user_id,
    required this.product_id,
    required this.store_id,
    required this.quantity,
    required this.product,
  });

  factory CartItems.fromJson(Map<String, dynamic> json) {
    return CartItems(
        id: json['id'],
        user_id: json['user_id'],
        store_id: json['store_id'],
        product_id: json['product_id'],
        quantity: int.parse(json['quantity'].toString()),
        product: Product.fromJson(json['product']));
  }
}
