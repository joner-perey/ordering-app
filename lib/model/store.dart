import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:lalaco/model/schedule.dart';

class Store {
  final int id;
  final String store_name;
  final String store_description;
  final String image;
  final String location_description;
  final String longitude;
  final String latitude;
  final int user_id;
  int subscription_count = 0;
  int is_user_subscribed = 0;
  final List<Schedule> schedules;

  Store({
    required this.id,
    required this.store_name,
    required this.store_description,
    required this.image,
    required this.location_description,
    required this.longitude,
    required this.latitude,
    required this.user_id,
    required this.subscription_count,
    required this.is_user_subscribed,
    required this.schedules
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    List<Schedule> schedules = [];

    if(json['schedules'] != null) {
      List<dynamic> schedulesJson = json['schedules'];

      for (var element in schedulesJson) {
        schedules.add(Schedule.fromJson(element));
      }
    }


    return Store(
        id: json['id'],
        store_name: json['store_name'],
        image: json['image'],
        store_description: json['store_description'],
        location_description: json['location_description'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        user_id: json['user_id'],
        subscription_count: json['subscription_count'] ?? 0,
        is_user_subscribed: json['is_user_subscribed'] ?? 0,
        schedules: schedules
    );
  }

  @override
  String toString() {
    return this.store_name;
  }

  Schedule? getScheduleNow() {
    var date = DateTime.now();

    var daysStr = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    var dayOfWeek = DateFormat('EEEE').format(date);
    var dayIndex = -1;

    var now = DateTime.now();
    var dateNow = DateFormat('yyyy-MM-dd').format(now);

    for (int i = 0; i < daysStr.length; i++) {
      if (daysStr[i] == dayOfWeek) {
        dayIndex = i;
        break;
      }

    }

    for (var schedule in schedules) {
      var daysJson = jsonDecode(schedule.days);

      if (daysJson[dayIndex] == true) {
        var startTime = DateTime.parse('$dateNow ${schedule.start_time}');
        var endTime = DateTime.parse('$dateNow ${schedule.end_time}');

        if (now.isAfter(startTime) && now.isBefore(endTime)) {
          return schedule;
        }
      }
    }

    return null;
  }

}