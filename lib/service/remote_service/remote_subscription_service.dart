import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/order.dart';
import 'package:lalaco/model/subscription.dart';

class RemoteSubscriptionService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/orders';

  Future<dynamic> fetchSubscriptions({required int storeId}) async {
    var response = await http.get(Uri.parse('$baseUrl/api/subscriptions/vendor?store_id=$storeId'));
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['subscriptions'];

    List<Subscription> subscriptions = [];
    if (response.statusCode == 200) {
      for (final result in results) {
        subscriptions.add(Subscription.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Subscriptions');
    }
    return subscriptions;
  }

  Future<dynamic> addSubscription({
    required user_id,
    required store_id,
  }) async {
    var body = {
      "user_id": user_id,
      "store_id": store_id,
    };
    var response = await client.post(
      Uri.parse('$baseUrl/api/subscriptions'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return response;
  }

  Future<dynamic> deleteSubscription({
    required user_id,
    required store_id,
  }) async {
    var body = {
      "user_id": user_id,
      "store_id": store_id,
    };
    var response = await client.delete(
      Uri.parse('$baseUrl/api/subscriptions'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return response;
  }
}
