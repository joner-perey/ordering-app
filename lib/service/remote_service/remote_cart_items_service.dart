import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/cart_items.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';

class RemoteCartItemsService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/cart_items';

  Future<dynamic> fetchCartItems() async {
    var response = await http.get(Uri.parse(remoteUrl));
    print(response.body);
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['cart_items'];

    List<CartItems> cartItems = [];

    if (response.statusCode == 200) {
      for (final result in results) {
        cartItems.add(CartItems.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Stores');
    }
    return cartItems;
  }

  Future<dynamic> addToCart({
    required int product_id,
    required int quantity,
    required int user_id,
    required int store_id,
  }) async {
    var body = {
      "product_id": product_id,
      "quantity": quantity,
      "user_id": user_id,
      "store_id": store_id,
    };
    var response = await client.post(
      Uri.parse('$baseUrl/api/cart_items'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    print(response.body);
    return response;
  }

  Future<dynamic> updateCartItemQuantity({
    required int cartItemId,
    required int newQuantity,
  }) async {
    var body = {
      "quantity": newQuantity,
    };
    var response = await client.put(
      Uri.parse('$baseUrl/api/cart_items/$cartItemId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    print(response.body);
    return response;
  }

  Future<dynamic> deleteCartItem(int cartItemId) async {
    var response = await client.delete(
      Uri.parse('$baseUrl/api/cart_items/$cartItemId'),
    );
    return response;
  }

  Future<dynamic> deleteAllCartItems(int storeId) async {
    var response = await client.delete(
      Uri.parse('$baseUrl/api/cart_items/delete_all/$storeId'),
    );
    print('$baseUrl/api/cart_items/delete_all/$storeId');
    return response;
  }



}
