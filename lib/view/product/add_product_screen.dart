import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lalaco/component/input_dropdown_button.dart';
import 'package:lalaco/component/input_outline_button.dart';
import 'package:lalaco/component/input_text_area.dart';
import 'package:lalaco/component/input_text_button.dart';
import 'package:lalaco/component/input_text_field.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/extension/string_extension.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/category.dart';
import 'package:lalaco/model/store.dart';

import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();

  Category? selectedCategory;
  Store? selectedStore;

  XFile? pickedImage;

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    super.dispose();
  }

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Add Product",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                  const Text(
                    "Fill up Product Information",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 10),
                  InputTextField(
                    title: 'Product Name',
                    textEditingController: productNameController,
                    validation: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  InputTextArea(
                    title: 'Product Description',
                    textEditingController: productDescriptionController,
                    validation: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  InputTextField(
                    title: 'Price',
                    textEditingController: productPriceController,
                    textInputType: TextInputType.number,
                    validation: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "This field can't be empty";
                      } else if (!value.isValidPrice) {
                        return "Please enter a valid product price";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  InputDropdownButton(
                    title: 'Category',
                    items: categoryController.categoryList,
                    value: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  InputDropdownButton(
                    title: 'Store',
                    items: storeController.storeList,
                    value: selectedStore,
                    onChanged: (value) {
                      setState(() {
                        selectedStore = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 50,
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InputTextButton(
                    title: "Add Product",
                    onClick: () {
                      // print(_image!.path);
                      if (_formKey.currentState!.validate()) {
                        productController.addProduct(
                            name: productNameController.text,
                            description: productDescriptionController.text,
                            price: double.parse(productPriceController.text),
                            category_id: selectedCategory!.id,
                            store_id: selectedStore!.id,
                            image: _image);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  InputOutlineButton(
                    title: "Back",
                    onClick: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
