import 'dart:convert';

import 'package:flutter/material.dart';

class Schedule {
  final int id;
  final int store_id;
  final String latitude;
  final String longitude;
  final String start_time;
  final String end_time;
  final String days;
  final String location_description;

  const Schedule({
    required this.id,
    required this.store_id,
    required this.latitude,
    required this.longitude,
    required this.start_time,
    required this.end_time,
    required this.days,
    required this.location_description,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    print('schedule');
    return Schedule(
      id: json['id'],
      store_id: json['store_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      start_time: json['start_time'],
      end_time: json['end_time'],
      days: json['days'],
      location_description: json['location_description'],
    );
  }

  TimeOfDay getEndTime() {
    var arrTime = end_time.split(':');

    var time = TimeOfDay(hour: int.parse(arrTime[0]), minute: int.parse(arrTime[1]));

    return time;
  }

  TimeOfDay getStartTime() {
    var arrTime = start_time.split(':');

    var time = TimeOfDay(hour: int.parse(arrTime[0]), minute: int.parse(arrTime[1]));

    return time;
  }

  String formatDays() {
    List<dynamic> daysArr = jsonDecode(days);
    List<String> daysStr = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    bool isEveryDay = true;
    String resultStr = '';

    for (int i = 0; i < daysArr.length; i++) {
      var day = daysArr[i];

      if (day == true) {
        resultStr += '${daysStr[i]} ';
      } else  {
        isEveryDay = false;
      }
    }

    if (isEveryDay) {
      return 'Everyday';
    }

    return resultStr;
  }
}
