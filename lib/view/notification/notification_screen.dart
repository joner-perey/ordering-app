import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/schedule.dart';
import 'package:lalaco/view/schedule/schedule_form.dart';
import 'package:lalaco/view/select_location/view_location.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    fetchNotifications();
    super.initState();
  }

  void fetchNotifications() async {
    var token = authController.localAuthService.getToken()!;
    await notificationController.getNotifications(token: token);
    await notificationController.readNotifications(token: token);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: notificationController.notificationList.isEmpty ? const Center(child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text('You Have No Notification', style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54
                ),),
              )) : Column(
                children: List<Widget>.generate(
                  notificationController.notificationList.length,
                      (index) {
                    final notification = notificationController.notificationList[index];

                    return Column(
                      children: [
                        ListTile(
                          title: Text('${notification.data['store_name']} - Your Order is now ${notification.data['status']}'),
                          subtitle: Text(DateFormat.yMMMd().add_jm().format(DateTime.parse(notification.created_at))),
                          onTap: () {
                            Navigator.pop(context, 'view_order');
                          },
                          trailing: notification.read_at != null ? null : const Icon(Icons.circle, color: Colors.blue, size: 10),
                          tileColor: notification.read_at != null ? null : Colors.blue[100],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      )
    )
    );
  }


}
