import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/store.dart';

class RemoteStoreService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/stores';

  Future<dynamic> fetchStores() async {
    var response = await http.get(Uri.parse(remoteUrl));
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

  Future<Store?> fetchStoreByUserId({ required int userId }) async {
    var response = await http.get(Uri.parse('$remoteUrl/by_user_id/$userId'));
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
}
