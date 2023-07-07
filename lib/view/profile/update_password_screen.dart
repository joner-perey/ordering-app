import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lalaco/component/input_outline_button.dart';
import 'package:lalaco/component/input_text_button.dart';
import 'package:lalaco/component/input_text_field.dart';
import 'package:lalaco/controller/controllers.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreen();
}

class _UpdatePasswordScreen extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text("Setting,",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                const Text(
                  "You can update your password here.",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2),
                ),
                const Spacer(
                  flex: 3,
                ),
                InputTextField(
                  title: 'Old Password',
                  obsecureText: true,
                  textEditingController: currentPasswordController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                InputTextField(
                  title: 'New Password',
                  obsecureText: true,
                  textEditingController: newPasswordController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                InputTextField(
                  title: 'Confirm New Password',
                  obsecureText: true,
                  textEditingController: confirmNewPasswordController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                InputTextButton(
                  title: "Update",
                  onClick: () {
                    if (_formKey.currentState!.validate()) {
                      if (newPasswordController.text ==
                          confirmNewPasswordController.text) {
                        authController.updatePassword(
                            id: int.parse(authController.user.value!.id),
                            current_password: currentPasswordController.text,
                            new_password: newPasswordController.text);
                      } else {
                        EasyLoading.showError(
                            'New password and confirm password not match',
                            dismissOnTap: false);
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                InputOutlineButton(
                  title: "Back",
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(
                  flex: 5,
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
