import 'package:lalaco/controller/auth_controller.dart';
import 'package:lalaco/controller/cart_items_controller.dart';
import 'package:lalaco/controller/category_controller.dart';
import 'package:lalaco/controller/home_controller.dart';
import 'package:lalaco/controller/notification_controller.dart';
import 'package:lalaco/controller/order_controller.dart';
import 'package:lalaco/controller/order_detail_controller.dart';
import 'package:lalaco/controller/product_controller.dart';
import 'package:lalaco/controller/schedule_controller.dart';
import 'package:lalaco/controller/store_controller.dart';
import 'package:lalaco/controller/subscription_controller.dart';

HomeController homeController = HomeController.instance;
ProductController productController = ProductController.instance;
AuthController authController = AuthController.instance;
CategoryController categoryController = CategoryController.instance;

StoreController storeController = StoreController.instance;
CartItemsController cartItemsController = CartItemsController.instance;

OrderController orderController = OrderController.instance;

ScheduleController scheduleController = ScheduleController.instance;

OrderDetailController orderDetailController = OrderDetailController.instance;
NotificationController notificationController = NotificationController.instance;
SubscriptionController subscriptionController = SubscriptionController.instance;



