import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lalaco/const.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/view/account/auth/sign_up_screen.dart';
import 'package:lalaco/view/notification/notification_screen.dart';
import 'package:lalaco/view/order/order_screen.dart';
import 'package:lalaco/view/profile/profile_screen.dart';
import 'package:lalaco/view/schedule/schedule_screen.dart';
import 'package:lalaco/view/profile/update_password_screen.dart';
import 'package:lalaco/view/store_form/store_form_screen.dart';

import 'auth/sign_in_screen.dart';

class AccountScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  AccountScreen({Key? key}) : super(key: key);

  void fetchNotifications() async {
    var token = authController.localAuthService.getToken()!;
    await notificationController.getNotifications(token: token);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 40),
          Obx(
            () => Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (authController.user.value != null) {
                      // final XFile? pickedImage =
                      //     await _picker.pickImage(source: ImageSource.gallery);
                      // if (pickedImage != null) {
                      //
                      // }

                      await authController.uploadProfilePicture();
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Obx(() =>
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: authController.user.value?.image !=
                                  null
                              ? NetworkImage(
                                      '$baseUrl/storage/uploads/${authController.user.value?.image}')
                                  as ImageProvider<Object>?
                              : const AssetImage("assets/user_image.png"),
                        )
                      ),
                      if (authController.user.value != null)
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      authController.user.value?.name ?? "Sign in your account",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          buildAccountCard(
              title: "Profile Info",
              onClick: () {
                if (authController.user.value != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                }
              }),
          Obx(() {
            if (authController.user.value?.user_type.toString() == 'Vendor') {
              return buildAccountCard(title: "My Store", onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StoreFormScreen()));
              });
            } else {
              // Return another widget or null if the condition is false
              return SizedBox.shrink();
            }
          }),
          buildAccountCard(
              title: "My Orders",
              onClick: () {
                if (authController.user.value != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderScreen()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                }
              }),
          Obx(() {
            if (authController.user.value?.user_type.toString() == 'Vendor') {
              return buildAccountCard(title: "My Schedule", onClick: () {


                if (authController.user.value != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScheduleScreen()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                }
              });
            } else {
              // Return another widget or null if the condition is false
              return SizedBox.shrink();
            }
          }),
          Obx(() {
                return buildAccountCard(title: "Notification", onClick: () {
                  if (authController.user.value != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen())).then((value) {

                      fetchNotifications();

                      String action = value as String;
                      if (action == 'view_order') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrderScreen()));
                      }


                    });
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  }



                });
          }),
          buildAccountCard(
              title: "Settings",
              onClick: () {
                if (authController.user.value != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UpdatePasswordScreen()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                }
              }),
          Obx(() => buildAccountCard(
              title: authController.user.value == null ? "Sign In" : "Sign Out",
              onClick: () {
                if (authController.user.value != null) {
                  authController.signOut();
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                }
              }))
        ],
      ),
    );
  }

  Widget buildAccountCard(
      {required String title, required Function() onClick}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () {
          onClick();
        },
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 0.1,
                  blurRadius: 7,
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              title == 'Notification' && notificationController.notificationCount.value > 0 ?
               Row(
                children: [
                  Icon(Icons.circle, color: Colors.redAccent, size: 15),
                  SizedBox(width: 5,),
                  Text(
                    '${notificationController.notificationCount}',
                    style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),

                  Icon(Icons.keyboard_arrow_right_outlined)
                ],
              )
              : const Icon(Icons.keyboard_arrow_right_outlined)

            ],
          ),
        ),
      ),
    );
  }
}
