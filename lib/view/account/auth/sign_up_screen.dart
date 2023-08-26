import 'package:flutter/material.dart';
import 'package:lalaco/component/input_dropdown_button.dart';
import 'package:lalaco/component/input_outline_button.dart';
import 'package:lalaco/component/input_text_button.dart';
import 'package:lalaco/component/input_text_field.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/extension/string_extension.dart';

import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? selectedUserType;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
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
                const Text("Create Account,",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                const Text(
                  "Sign up to started!",
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
                InputDropdownButton(
                  title: 'User Type',
                  items: ['Customer', 'Vendor', 'Admin'],
                  value: selectedUserType,
                  onChanged: (value) {
                    setState(() {
                      selectedUserType = value;
                    });
                  },
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an option';
                    }
                    return null; // Return null if the value is valid
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
                      return "Please enter valid Mobile No.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                InputTextField(
                  title: 'Password',
                  obsecureText: true,
                  textEditingController: passwordController,
                  validation: (String? value) {
                    List<String> _validation = [];
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    } else {
                      if (!value.isValidPasswordHasNumber) {
                        _validation.add("Must contain 1 number");
                      }
                      if (!value.isValidPasswordHasCapitalLetter) {
                        _validation.add("Must contain 1 capital letter");
                      }
                      if (!value.isValidPasswordHasLowerCaseLetter) {
                        _validation.add("Must contain 1 simple letter");
                      }
                      if (!value.isValidPasswordHasSpecialCharacter) {
                        _validation.add(
                            "Must contain 1 special character[! @ # \$ %]");
                      }
                    }
                    String msg = '';
                    if (_validation.isNotEmpty) {
                      for (var i = 0; i < _validation.length; i++) {
                        msg = msg + _validation[i];
                        if ((i + 1) != _validation.length) {
                          msg = msg + "\n";
                        }
                      }
                    }
                    return msg.isNotEmpty ? msg : null;
                  },
                ),
                const SizedBox(height: 10),
                InputTextField(
                  title: 'Confirm Password',
                  obsecureText: true,
                  textEditingController: confirmController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    } else if (passwordController.text != value) {
                      return "Confirm password not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Spacer(),
                InputTextButton(
                  title: "Sign Up",
                  onClick: () {
                    if (_formKey.currentState!.validate()) {
                      authController.signUp(
                        name: fullNameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        password: passwordController.text,
                        user_type: selectedUserType.toString(),
                      );

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("I'm already a member, "),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
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
