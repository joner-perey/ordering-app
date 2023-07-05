import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/category.dart';


class RemoteCategoryService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/categories';

  Future<dynamic> fetchCategories() async {
    var response = await http.get(Uri.parse(remoteUrl));
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['product_categories'];

    List<Category> categories = [];

    if (response.statusCode == 200) {
      for (final result in results) {
        categories.add(Category.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Stores');
    }
    return categories;
  }

}
