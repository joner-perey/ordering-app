import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/rating.dart';
import 'package:lalaco/model/store.dart';

class RemoteRatingService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/ratings';

  Future<dynamic> getByStoreId({required int store_id}) async {
    debugPrint('$remoteUrl/?store_id=$store_id');
    var response =
        await client.get(Uri.parse('$remoteUrl/?store_id=$store_id'));
    print(response.body);
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['ratings'];

    List<Rating> ratings = [];

    if (response.statusCode == 200) {
      for (final result in results) {
        ratings.add(Rating.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Ratings');
    }
    return ratings;
  }

  Future<double> getAverageRatingByStoreId({required int store_id}) async {
    var response =
        await client.get(Uri.parse('$remoteUrl/?store_id=$store_id'));
    print(response.body);
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['ratings'];

    List<Rating> ratings = [];

    if (response.statusCode == 200) {
      for (final result in results) {
        ratings.add(Rating.fromJson(result));
      }

      // Calculate the average rating
      double totalRating = 0;
      for (final rating in ratings) {
        totalRating += rating.rate;
      }
      double averageRating = totalRating / ratings.length;
      return averageRating;
    } else {
      throw Exception('Failed to load Ratings');
    }
  }

  Future<dynamic> addRating({
    required int store_id,
    required int user_id,
    required String comment,
    required double rate,
    required int order_id,
  }) async {
    var body = {
      "store_id": store_id,
      "user_id": user_id,
      "comment": comment,
      "rate": rate,
      "order_id": order_id,
    };
    var response = await client.post(
      Uri.parse('$baseUrl/api/ratings'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    print(response.body);
    return response;
  }
}
