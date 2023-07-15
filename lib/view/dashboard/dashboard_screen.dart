import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/controller/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/view/account/account_screen.dart';
import 'package:lalaco/view/home/components/home_screen.dart';
import 'package:lalaco/view/map/map_screen.dart';
import 'package:lalaco/view/product/product_screen.dart';
import 'package:lalaco/view/store_details/store_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
  late Store store;

  @override
  void initState() {
    if (authController.user.value != null &&
        authController.user.value?.user_type == 'Vendor') {
      fetchStoreData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: controller.tabIndex,
            children: [
              HomeScreen(),
              ProductScreen(),
              MapSample(),
              AccountScreen(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 0.7))),
          child: SnakeNavigationBar.color(
            behaviour: SnakeBarBehaviour.floating,
            snakeShape: SnakeShape.circle,
            padding: const EdgeInsets.symmetric(vertical: 5),
            // unselectedLabelStyle: const TextStyle(fontSize: 11),
            snakeViewColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            showUnselectedLabels: true,
            currentIndex: controller.tabIndex,
            onTap: (val) {
              controller.updateIndex(val);
              productController.getProducts();
              storeController.getStores(userId: authController.localAuthService.getUserId()!.toString());
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Products'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), label: 'Account'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchStoreData() async {
    try {
      if (authController.user.value != null) {
        var result = await storeController.getStoreByUserId(
            user_id: int.parse(authController.user.value!.id));
        setState(() {
          store = result!;
        });
        print(store.id);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
