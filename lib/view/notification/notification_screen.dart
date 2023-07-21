import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/schedule.dart';
import 'package:lalaco/view/schedule/schedule_form.dart';
import 'package:lalaco/view/select_location/view_location.dart';

import '../../model/store.dart';
import '../store_details/store_details_screen.dart';

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
            notificationController.isNotificationLoading.value ?
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(child: CircularProgressIndicator()),
            ) :
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

                    String notifContent = '';
                    String action = '';

                    if (notification.type == 'App\\Notifications\\OrderStatusUpdateNotification') {
                      notifContent = '${notification.data['store_name']} - Your Order is now ${notification.data['status']}';
                      action = 'view_order';
                    } else if (notification.type == 'App\\Notifications\\NewSubscriberNotification') {
                      notifContent = '${notification.data['user_name']} Subscribed to ${notification.data['store_name']}';
                    } else if (notification.type == 'App\\Notifications\\NewProductNotification') {
                      notifContent = '${notification.data['store_name']} - We have a new product. It\'s ${notification.data['product_name']} and for only ${notification.data['price']} pesos';
                      action = 'view_store';
                    } else if (notification.type == 'App\\Notifications\\UpdateProductNotification') {
                      notifContent = '${notification.data['store_name']} - We have updated our product ${notification.data['product_name']}';
                      action = 'view_store';
                    }

                    return Column(
                      children: [
                        ListTile(
                          title: Text(notifContent),
                          subtitle: Text(DateFormat.yMMMd().add_jm().format(DateTime.parse(notification.created_at).toLocal())),
                          onTap: () async {
                            if (action == 'view_order') {
                              Navigator.pop(context, 'view_order');
                            } else if (action == 'view_store') {
                              EasyLoading.show(status: 'Loading', dismissOnTap: false);
                              Store? store = await storeController.getStoreById(storeId: notification.data['store_id'], userId: int.parse(authController.user.value!.id));
                              EasyLoading.dismiss();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StoreDetailsScreen(store: store!)));
                            }

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
