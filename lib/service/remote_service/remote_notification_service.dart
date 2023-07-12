import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/notification.dart';


class RemoteNotificationService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/notifications';

  Future<List<NotificationModel>> fetchNotifications({required String token}) async {
    var response = await http.get(Uri.parse(remoteUrl), headers: {
      'Authorization': 'Bearer $token'
    });
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['notifications'];

    List<NotificationModel> categories = [];
    if (response.statusCode == 200) {
      for (final result in results) {
        categories.add(NotificationModel.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Notifications');
    }
    return categories;
  }

  Future<void> readNotifications({required String token}) async {
    var response = await http.post(Uri.parse('$remoteUrl/read_notifications'), headers: {
      'Authorization': 'Bearer $token'
    });
  }

}