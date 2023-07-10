import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:lalaco/service/remote_service/remote_schedule_service.dart';

import '../model/schedule.dart';

class ScheduleController extends GetxController {
  static ScheduleController instance = Get.find();
  RxBool isScheduleLoading = false.obs;
  RxList<Schedule> scheduleList = List<Schedule>.empty(growable: true).obs;


  Future<void> getSchedules({ required int storeId }) async {
    try {
      isScheduleLoading(true);
      //call api
      var result = await RemoteScheduleService().fetchSchedules(storeId: storeId);
      if (result != null) {
        //assign api result
        scheduleList.assignAll(result);
      }
    } finally {
      isScheduleLoading(false);
    }
  }

  void updateSchedule({
    required int schedule_id,
    required String store_id,
    required String location_description,
    required String start_time,
    required String end_time,
    required String longitude,
    required String latitude,
    required String days
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteScheduleService().updateSchedule(
        schedule_id: schedule_id,
        store_id: store_id,
        location_description: location_description,
        longitude: longitude,
        latitude: latitude,
        start_time: start_time,
        end_time: end_time,
        days: days,
      );
      if (result.statusCode == 201 || result.statusCode == 200) {
        EasyLoading.showSuccess("Schedule Updated");
        Navigator.of(Get.overlayContext!).pop();
      } else if (result.statusCode == 422) {
        EasyLoading.showError(jsonDecode(result.body)['message']);
      }
    } catch (e) {
      EasyLoading.showError('2!');
    } finally {
      EasyLoading.dismiss();
    }
  }


  void addSchedule({
    required String store_id,
    required String location_description,
    required String start_time,
    required String end_time,
    required String longitude,
    required String latitude,
    required String days
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteScheduleService().addSchedule(
        store_id: store_id,
        location_description: location_description,
        longitude: longitude,
        latitude: latitude,
        start_time: start_time,
        end_time: end_time,
        days: days,
      );
      if (result.statusCode == 201 || result.statusCode == 200) {
        EasyLoading.showSuccess("Schedule Added");
        Navigator.of(Get.overlayContext!).pop();
      } else if (result.statusCode == 422) {
        EasyLoading.showError(jsonDecode(result.body)['message']);
      }
    } catch (e) {
      EasyLoading.showError('2!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteSchedule({
    required int schedule_id,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteScheduleService().deleteSchedule(
          schedule_id: schedule_id
      );
      if (result.statusCode == 201 || result.statusCode == 200) {
        EasyLoading.showSuccess("Schedule Deleted");
        Navigator.of(Get.overlayContext!).pop();
      } else {
        EasyLoading.showError('1!');
      }
    } catch (e) {
      EasyLoading.showError('2!');
    } finally {
      EasyLoading.dismiss();
    }
  }
}