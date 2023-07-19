import 'package:lalaco/model/category.dart';

class Product {
  final int id;
  final String name;
  final String image;
  final String description;
  final double price;

  final int category_id;
  final int store_id;
  final Category? category;

  const Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.category_id,
    required this.store_id,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        description: json['description'],
        price: double.parse(json['price']),
        category_id: json['category_id'],
        store_id: json['store_id'],

        category: json['category'] == null ? null : Category.fromJson(json['category']));
  }
}
