import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/schedule.dart';
import 'package:lalaco/view/schedule/schedule_form.dart';
import 'package:lalaco/view/select_location/view_location.dart';

import '../../const.dart';

class SubscriptionScreen extends StatefulWidget {
  final int storeId;

  const SubscriptionScreen({Key? key, required this.storeId}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {

  @override
  void initState() {
    fetchNotifications();
    super.initState();
  }

  void fetchNotifications() async {
    await subscriptionController.fetchSubscriptions(storeId: widget.storeId);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
        appBar: AppBar(
          title: const Text('Subscribers'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            subscriptionController.isSubscriptionLoading.value ? const Center(child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: CircularProgressIndicator(),),
              ) :
              SizedBox(
                child: subscriptionController.subscriptionList.isEmpty ? const Center(child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text('No Subscriber', style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54
                  ),),
                )) : Column(
                  children: List<Widget>.generate(
                    subscriptionController.subscriptionList.length,
                        (index) {
                      final subscriber = subscriptionController.subscriptionList[index];

                      return Column(
                        children: [
                          ListTile(
                            title: Text(subscriber.user.name),
                            onTap: () {
                              // Navigator.pop(context, 'view_order');
                            },
                            leading: CircleAvatar(
                              backgroundImage: subscriber.user.image !=
                                  null
                                  ? NetworkImage(
                                  '$baseUrl/storage/uploads/${subscriber.user.image}')
                              as ImageProvider<Object>?
                                  : const AssetImage("assets/user_image.png"),
                            ),
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
