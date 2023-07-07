import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/order.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';


class RemoteScheduleService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/schedules';

  Future<dynamic> addSchedule({
    required String store_id,
    required String location_description,
    required String start_time,
    required String end_time,
    required String longitude,
    required String latitude,
    required String days
  }) async {
    var body = {
      "store_id": store_id,
      "location_description": location_description,
      "longitude": longitude,
      "latitude": latitude,
      "start_time": start_time,
      "end_time": end_time,
      "days": days,
    };
    var response = await client.post(
      Uri.parse('$baseUrl/api/schedules'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    print(body);
    print(response.statusCode);
    print(response.body);
    return response;
  }
}