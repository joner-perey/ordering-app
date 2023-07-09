import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lalaco/model/ad_banner.dart';
import 'package:lalaco/model/category.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/user.dart';
import 'package:lalaco/route/app_page.dart';
import 'package:lalaco/route/app_route.dart';
import 'package:lalaco/theme/app_theme.dart';

import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

Future<dynamic> onSelectNotification(String payload) async {
  /*Do whatever you want to do on notification click. In this case, I'll show an alert dialog*/
}

var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload, {
      String channelId = '1234',
      String channelTitle = 'Android Channel',
      String channelDescription = 'Default Android Channel for notifications',
      Priority notificationPriority = Priority.high,
      Importance notificationImportance = Importance.max,
    }) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId,
    channelTitle,
    channelDescription: channelDescription,
    playSound: false,
    importance: notificationImportance,
    priority: notificationPriority,
  );
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    notificationId,
    notificationTitle,
    notificationContent,
    platformChannelSpecifics,
    payload: payload,
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Firebase Messaging firebase is initialized");
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Firebase.initializeApp();



  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // debugPrint(fcmToken);

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  Hive.registerAdapter(UserAdapter());

  // local notification
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    _showNotification(id, message.notification!.title!, message.notification!.body!, "Payload");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppPage.list,
      initialRoute: AppRoute.dashboard,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      builder: EasyLoading.init(),
    );
  }
}
