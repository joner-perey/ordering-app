import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/store.dart';

class RemoteStoreService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/stores';

  Future<dynamic> fetchStores({required String userId}) async {
    var response =
        await http.get(Uri.parse('$remoteUrl?user_id=$userId'), headers: {
      "Content-Type": "application/json",
    });

    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['stores'];

    List<Store> stores = [];

    if (response.statusCode == 200) {
      for (final result in results) {
        stores.add(Store.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Stores');
    }

    return stores;
  }

  Future<Store?> fetchStoreByUserId({required int user_id}) async {
    var response = await http.get(Uri.parse('$remoteUrl/by_user_id/$user_id'));
    final parsedJson = jsonDecode(response.body);
    final result = parsedJson['store'];

    Store? store;

    if (response.statusCode == 200) {
      store = Store.fromJson(result);
    } else {
      throw Exception('Failed to load Stores');
    }

    return store;
  }

  Future<Store?> fetchStoreById({required int storeId, required int userId}) async {
    var response = await http.get(Uri.parse('$remoteUrl/$storeId?user_id=$userId'));
    final parsedJson = jsonDecode(response.body);
    final result = parsedJson['store'];

    Store? store;

    if (response.statusCode == 200) {
      store = Store.fromJson(result);
    } else {
      throw Exception('Failed to load Store');
    }

    return store;
  }

  Future<dynamic> getByName({required String keyword}) async {
    var response = await client.get(Uri.parse('$remoteUrl?search=$keyword'));
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['stores'];

    List<Store> stores = [];

    if (response.statusCode == 200) {
      for (final result in results) {
        stores.add(Store.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Stores');
    }

    return stores;
  }

  Future<dynamic> updateStore(
      {required int id,
      required String store_name,
      required File? image,
      required String store_description,
      required String location_description,
      required String longitude,
      required String latitude}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/stores/$id'),
    );
    request.fields['is_active'] = '1';
    request.fields['store_name'] = store_name;
    request.fields['store_description'] = store_description;
    request.fields['location_description'] = location_description;
    request.fields['longitude'] = longitude;
    request.fields['latitude'] = latitude;

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
}
