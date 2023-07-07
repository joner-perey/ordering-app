import 'package:flutter/material.dart';
import 'package:lalaco/component/input_outline_button.dart';
import 'package:lalaco/component/input_text_button.dart';
import 'package:lalaco/component/input_text_field.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/extension/string_extension.dart';

class StoreFormScreen extends StatefulWidget {
  const StoreFormScreen({Key? key}) : super(key: key);

  @override
  State<StoreFormScreen> createState() => _StoreFormScreenState();
}

class _StoreFormScreenState extends State<StoreFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController =
  TextEditingController(text: authController.user.value?.name);
  TextEditingController emailController =
  TextEditingController(text: authController.user.value?.email);
  TextEditingController phoneController =
  TextEditingController(text: authController.user.value?.phone_number);

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
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
                const Text("Store Info,",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                const Text(
                  "You can update your store info.",
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
                  title: 'Full Name',
                  textEditingController: fullNameController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                InputTextField(
                  title: 'Email',
                  textEditingController: emailController,
                  // initialValue: authController.user.value?.email,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    } else if (!value.isValidEmail) {
                      return "Please enter valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                InputTextField(
                  title: 'Mobile No.',
                  textEditingController: phoneController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    } else if (!value.isValidPhone) {
                      return "Please enter valid phone number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Spacer(),
                InputTextButton(
                  title: "Update",
                  onClick: () {
                    if (_formKey.currentState!.validate()) {
                      authController.updateProfile(
                          id: int.parse(authController.user.value!.id),
                          name: fullNameController.text,
                          email: emailController.text,
                          phone_number: phoneController.text);
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
