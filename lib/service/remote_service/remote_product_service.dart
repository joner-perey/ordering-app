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

  Future<dynamic> fetchProducts() async {
    var response = await http.get(Uri.parse(remoteUrl));
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
    debugPrint('$remoteUrl/products/$id');
    var response = await client.get(Uri.parse('$remoteUrl/products/$id'));
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

  Future<dynamic> getProductsPerStore({required int store_id}) async {
    var response = await client.get(Uri.parse('$baseUrl/api/products/per_store?store_id=$store_id'));
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
}
