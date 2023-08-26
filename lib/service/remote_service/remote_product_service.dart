import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';

class RemoteProductService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/products/search';

  Future<dynamic> fetchProducts({ required String userId }) async {
    var response = await http.get(Uri.parse('$remoteUrl?user_id=$userId'));
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['products'];

    print(response.body);
    print('userId: $userId');

    List<Product> products = [];

    if (response.statusCode == 200) {
      for (final result in results) {
        products.add(Product.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Products');
    }
    return products;
  }

  Future<dynamic> getByName({required String keyword}) async {
    debugPrint('$remoteUrl?search=$keyword');
    var response = await client.get(Uri.parse('$remoteUrl?search=$keyword'));
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['products'];

    List<Product> products = [];

    if (response.statusCode == 200) {
      for (final result in results) {
        products.add(Product.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Stores');
    }

    return products;
  }

  Future<dynamic> getById({required int id}) async {
    var response = await client.get(Uri.parse('$baseUrl/api/products/$id'));
    final parsedJson = jsonDecode(response.body);
    final result = parsedJson['product'];

    List<Product> products = [];

    if (response.statusCode == 200) {
      return Product.fromJson(result);
    } else {
      throw Exception('Failed to load Stores');
    }

    return products;
  }

  Future<dynamic> getProductsPerStore({required int store_id}) async {
    var response = await client
        .get(Uri.parse('$baseUrl/api/products/per_store?store_id=$store_id'));
    print(response.statusCode);
    print('asdasd');
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['products'];

    List<Product> products = [];

    if (response.statusCode == 200) {
      for (final result in results) {
        products.add(Product.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Stores');
    }

    return products;
  }

  Future<dynamic> addProduct({
    required String name,
    required String description,
    required double price,
    required int category_id,
    required int store_id,
    File? image,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/products'),
    );

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['category_id'] = category_id.toString();
    request.fields['store_id'] = store_id.toString();

    if (image != null) {
      var imageStream = await image.readAsBytes();
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageStream,
        filename: image.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();
    return response;
  }

  Future<dynamic> updateProduct({
    required int id,
    required String name,
    required String description,
    required double price,
    required int category_id,
    required File? image,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/products/$id'),
    );
    request.headers["Accept"] = "application/json";
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['category_id'] = category_id.toString();

    if (image != null) {
      var imageStream = await image.readAsBytes();
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageStream,
        filename: image.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    print(responseBody);
    return response;
  }

  Future<dynamic> deleteProduct(int product_id) async {
    var response = await client.delete(
      Uri.parse('$baseUrl/api/products/$product_id'),
    );
    return response;
  }

  Future<dynamic> deleteProductsPerStore(int store_id) async {
    var response = await client.delete(
      Uri.parse('$baseUrl/api/products/per_store/$store_id'),
    );
    return response;
  }
}
