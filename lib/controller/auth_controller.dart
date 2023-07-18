import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lalaco/const.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/model/user.dart';
import 'package:lalaco/service/remote_service/remote_auth_service.dart';
import 'package:lalaco/service/local_service/local_auth_service.dart';

import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  Rxn<User> user = Rxn<User>();
  Rxn<Store> store = Rxn<Store>();
  int? walk_through;
  final LocalAuthService localAuthService = LocalAuthService();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() async {
    await localAuthService.init();

    walk_through = localAuthService.getWalkThrough();
    int? userId = localAuthService.getUserId();
    if (userId != null) {
      User? _user = await fetchUser(userId: userId);

      user.value = _user;

      if (user.value?.user_type == 'Vendor') {
        Store? _store = await storeController.getStoreByUserId(
            user_id: int.parse(user.value!.id));

        if (_store != null) {
          store.value = _store;
          await localAuthService.addStore(store: _store);
        }
      }
    }


    super.onInit();
  }

  Future<User?> fetchUser({required int userId}) async {
    var result = await RemoteAuthService().getUser(userId: userId);

    if (result.statusCode == 200) {
      var user = User.fromJson(json.decode(result.body)['user']);

      return user;
    }

    return null;
}

  Future<void> uploadProfilePicture() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      try {
        EasyLoading.show(status: 'Uploading...', dismissOnTap: false);
        final url = Uri.parse(
            '$baseUrl/api/users/${authController.user.value!.id}/upload_image'); // Replace with your upload image endpoint URL
        final request = http.MultipartRequest('POST', url);
        request.files
            .add(await http.MultipartFile.fromPath('image', pickedImage.path));
        final response = await request.send();
        if (response.statusCode == 200) {
          // Image uploaded successfully
          final responseData = await response.stream.bytesToString();
          final message = json.decode(responseData)['message'];
          final userResponse = User.fromJson(json.decode(responseData)['user']);
          EasyLoading.showSuccess(message);
          // user.value = _localAuthService.getUser();
          // Optionally, you can update the user's profile image in the user object
          user.value = userResponse;
        } else {
          // Image upload failed
          print(response.statusCode);
          EasyLoading.showError('Image upload failed');
        }
      } catch (e) {
        // Error occurred during image upload
        print(e);
        EasyLoading.showError('Image upload failed');
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  void signUp({
    required String name,
    required String email,
    required String password,
    required String user_type,
    required String phone,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteAuthService().signUp(
        email: email,
        password: password,
        name: name,
        user_type: user_type,
        phone: phone,
      );
      print(result.statusCode);
      if (result.statusCode == 200 || result.statusCode == 201) {
        // String token = json.decode(result.body)['token'];
        // var userResult = await RemoteAuthService().createProfile(fullName: fullName, token: token);
        // if(userResult.statusCode == 200) {
        //   user.value = userFromJson(userResult.body);
        // await _localAuthService.addToken(token: token);
        // await _localAuthService.addUser(user: user);
        EasyLoading.showSuccess("Welcome to Lalaco!");
        Navigator.of(Get.overlayContext!).pop();
        // } else {
        //   EasyLoading.showError('Something wrong. Try again!');
        // }
      } else {
        EasyLoading.showError('1Something wrong. Try again!');
      }
    } catch (e) {
      EasyLoading.showError('2Something wrong. Try again!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void signIn({required String email, required String password}) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteAuthService().signIn(
        email: email,
        password: password,
      );
      if (result.statusCode == 200) {
        User _user = User.fromJson(json.decode(result.body)['user']);
        String token = json.decode(result.body)['token'];

        user.value = _user;

        // var userResult = await RemoteAuthService().getProfile(token: token);
        // if (userResult.statusCode == 200) {
        //   user.value = userFromJson(userResult.body);
        await localAuthService.addToken(token: token);
        await localAuthService.addUser(user: _user);
        await localAuthService.addUserId(userId: int.parse(_user.id));
        await localAuthService.updateWalkThrough(walkThrough: json.decode(result.body)['user']['walk_through']);


        // update fcm token
        final fcmToken = await FirebaseMessaging.instance.getToken();
        await RemoteAuthService().updateFcmToken(auth_token: token, fcm_token: fcmToken!);

        if (_user.user_type == 'Vendor') {
          Store? _store = await storeController.getStoreByUserId(
              user_id: int.parse(_user.id));

          if (_store != null) {
            store.value = _store;
            await localAuthService.addStore(store: _store);
          }
        }

        EasyLoading.showSuccess("Welcome to Lalaco!");
        Navigator.of(Get.overlayContext!).pop();
        // }
        // else {
        //     EasyLoading.showError('Something wrong. Try again!');
        //   }
      } else {
        EasyLoading.showError('Username/password wrong');
      }
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError('Something wrong. Try again!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateProfile(
      {required int id,
      required String name,
      required String email,
      required String phone_number}) async {
    try {
      EasyLoading.show(status: 'Updating...', dismissOnTap: false);
      var result = await RemoteAuthService().updateProfile(
        token: localAuthService.getToken(),
        id: id,
        name: name,
        email: email,
        phone_number: phone_number,
      );
      if (result.statusCode == 200) {
        // Profile updated successfully
        EasyLoading.showSuccess('Profile updated successfully');

        // Optionally, you can update the user object with the updated profile data
        user.value?.name = name;
        user.value?.email = email;
        user.value?.phone_number = phone_number;
      } else {
        // Profile update failed
        EasyLoading.showError('Profile update failed');
      }
    } catch (e) {
      // Error occurred during profile update
      EasyLoading.showError('Profile update failed');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updatePassword({
    required int id,
    required String current_password,
    required String new_password,
  }) async {
    try {
      EasyLoading.show(status: 'Updating...', dismissOnTap: false);
      var result = await RemoteAuthService().updatePassword(
        token: localAuthService.getToken(),
        id: id,
        current_password: current_password,
        new_password: new_password,
      );
      if (result.statusCode == 200) {
        EasyLoading.showSuccess('Password updated successfully');
        Navigator.of(Get.overlayContext!).pop();
      } else {
        // Profile update failed
        EasyLoading.showError('Password update failed');
      }
    } catch (e) {
      // Error occurred during profile update
      EasyLoading.showError('Password update failed');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateLocation({
    required String latitude,
    required String longitude,
  }) async {
    try {
      var result = await RemoteAuthService().updateLocation(
        auth_token: localAuthService.getToken(),
        latitude: latitude,
        longitude: longitude,
      );
      if (result.statusCode == 200) {
        print('Customer Location Updated');
      }
    } catch (e) {
      // Error occurred during location update
    }
  }

  Future<void> updateWalkThrough() async {
    await RemoteAuthService().updateWalkThrough(auth_token: localAuthService.getToken());
  }

  void signOut() async {
    user.value = null;
    await localAuthService.clear();
  }
}
