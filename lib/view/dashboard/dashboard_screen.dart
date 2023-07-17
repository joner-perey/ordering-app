import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/controller/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/view/account/account_screen.dart';
import 'package:lalaco/view/home/components/home_screen.dart';
import 'package:lalaco/view/map/map_screen.dart';
import 'package:lalaco/view/product/product_screen.dart';
import 'package:lalaco/view/store_details/store_details_screen.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';


typedef VoidCallback = dynamic Function();

class Throttler {
  final int throttleGapInMillis;
  int? lastActionTime;

  Throttler({required this.throttleGapInMillis});

  void run(VoidCallback action) {
    if (lastActionTime == null) {
      action();
      lastActionTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      if (DateTime.now().millisecondsSinceEpoch - lastActionTime! > (throttleGapInMillis ?? 5000)) {
        action();
        lastActionTime = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
  Store? store;

  List<TargetFocus> targets = [];

  late DashboardController dashboardController;

  GlobalKey keyHome = GlobalKey();
  GlobalKey keyProduct = GlobalKey();
  GlobalKey keyMap = GlobalKey();
  GlobalKey keyAccount = GlobalKey();

  int indexTarget = 0;

  var throttler = Throttler(throttleGapInMillis: 5000);

  MapSample? mapSample;
  GlobalKey<MapSampleState> _mapSampleKey = GlobalKey();

  Future<void> updateUserLocation() async {
    var position = await getUserCurrentLocation();

    authController.updateLocation(latitude: position.latitude.toString(), longitude: position.longitude.toString());
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    var position = await Geolocator.getCurrentPosition();

    return position;
  }

  @override
  void initState() {
    authController.onInit();

    mapSample = MapSample(key: _mapSampleKey);

    targets.add(
        TargetFocus(
            identify: "Target 1",
            keyTarget: keyHome,
            contents: [
              TargetContent(
                  align: ContentAlign.top,
                  child: Container(
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Welcome to Lalaco",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.0
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text("Here in the home tab, you can see the available Products and Stores in Lalaco",
                            style: TextStyle(
                                color: Colors.white
                            ),),
                        )
                      ],
                    ),
                  )
              )
            ]
        )
    );

    targets.add(
        TargetFocus(
            identify: "Target 2",
            keyTarget: keyProduct,
            contents: [
              TargetContent(
                  align: ContentAlign.top,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Products Tab",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.0
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text("If you go to the Products Tab. You can browse all the available Products",
                            style: TextStyle(
                                color: Colors.white
                            ),),
                        )
                      ],
                    ),
                  )
              )
            ]
        )
    );

    targets.add(
        TargetFocus(
            identify: "Target 3",
            keyTarget: keyMap,
            contents: [
              TargetContent(
                  align: ContentAlign.top,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Maps Tab",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.0
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text("If you go the the Maps Tab. You can view all available street vendors within the vicinity",
                            style: TextStyle(
                                color: Colors.white
                            ),),
                        )
                      ],
                    ),
                  )
              )
            ]
        )
    );

    targets.add(
        TargetFocus(
            identify: "Target 4",
            keyTarget: keyAccount,
            contents: [
              TargetContent(
                  align: ContentAlign.top,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Account Tab",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.0
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text("If you go the the Account Tab. You can view your Profile Info, Orders, and Notifications.",
                            style: TextStyle(
                                color: Colors.white
                            ),),
                        )
                      ],
                    ),
                  )
              )
            ]
        )
    );



    Timer(Duration(seconds: 3), () async {
      await storeController.getStores(userId: authController.localAuthService.getUserId()!.toString());
    });

    super.initState();
  }

  void handleShowTutorial() {
    Timer(Duration(seconds: 3), () {
      int? walkThrough = authController.localAuthService.getWalkThrough();

      print('walkthrough $walkThrough');

      if (walkThrough == 0 && authController.user.value!.user_type == 'Customer') {
        showTutorial();
      }
    });
  }

  void showTutorial() {
    TutorialCoachMark(
      targets: targets, // List<TargetFocus>
      colorShadow: Colors.orangeAccent, // DEFAULT Colors.black
      // alignSkip: Alignment.bottomRight,
      // textSkip: "SKIP",
      // paddingFocus: 10,
      // opacityShadow: 0.8,
      showSkipInLastTarget: false,
      onClickTarget: (target){

        if (indexTarget == 3) {
          return;
        }

        dashboardController.updateIndex(++indexTarget);
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target){
        print(target);
      },
      onSkip: (){
        print("skip");
        authController.updateWalkThrough();
      },
      onFinish: (){
        print("finish");
        authController.updateWalkThrough();
      },
    )..show(context:context);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {

        dashboardController = controller;
      return Scaffold(

        body: SafeArea(
          child: IndexedStack(
            index: controller.tabIndex,
            children: [
              HomeScreen(),
              store == null
                  ? ProductScreen()
                  : StoreDetailsScreen(store: store!),
              mapSample!,
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
              if (val == 0) {
                handleShowTutorial();
              }

              controller.updateIndex(val);
              productController.getProducts();





              if (authController.user.value != null &&
                  authController.user.value?.user_type == 'Vendor') {
                fetchStoreData();
              } else {
                store = null;
              }

              if (authController.user.value != null &&
                  authController.user.value?.user_type == 'Customer') {
                throttler.run(() {
                  updateUserLocation();
                  _mapSampleKey.currentState?.handleDisplayMarkers();
                });
              }

              if (authController.user.value != null &&
                  authController.user.value?.user_type == 'Vendor') {
                throttler.run(() {
                  _mapSampleKey.currentState?.handleDisplayMarkers();
                  storeController.getStores(userId: authController.localAuthService.getUserId()!.toString());
                });
              }



            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home, key: keyHome,), label: 'Home'),
              store == null
                  ? BottomNavigationBarItem(
                      icon: Icon(Icons.category, key: keyProduct,), label: 'Products')
                  : BottomNavigationBarItem(
                      icon: Icon(Icons.store, key: keyProduct), label: 'My Store'),
              BottomNavigationBarItem(icon: Icon(Icons.map, key: keyMap,), label: 'Map'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle, key: keyAccount,), label: 'Account'),
            ],
          ),
        ),
      );
  }
    );
  }

  Future<void> fetchStoreData() async {
    try {
      if (authController.user.value != null) {
        var result = await storeController.getStoreByUserId(
            user_id: int.parse(authController.user.value!.id));
        print(store?.id);
        setState(() {
          store = result!;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
