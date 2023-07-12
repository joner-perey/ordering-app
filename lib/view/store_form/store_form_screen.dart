import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lalaco/component/input_outline_button.dart';
import 'package:lalaco/component/input_text_area.dart';
import 'package:lalaco/component/input_text_button.dart';
import 'package:lalaco/component/input_text_field.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/extension/string_extension.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/view/select_location/select_location.dart';

class StoreFormScreen extends StatefulWidget {
  const StoreFormScreen({Key? key}) : super(key: key);

  @override
  State<StoreFormScreen> createState() => _StoreFormScreenState();
}

class _StoreFormScreenState extends State<StoreFormScreen> {
  late Store store;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController storeNameController;
  late TextEditingController storeDescriptionController;
  late TextEditingController locationDescriptionController;

  late String image;
  late String longitude;
  late String latitude;

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
  void initState() {
    fetchStoreData(); // Call the function when the screen initializes
    storeNameController = TextEditingController();
    storeDescriptionController = TextEditingController();
    locationDescriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    storeNameController.dispose();
    storeDescriptionController.dispose();
    locationDescriptionController.dispose();
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
                  title: 'Store Name',
                  textEditingController: storeNameController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                InputTextArea(
                  title: 'Store Description',
                  textEditingController: storeDescriptionController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                InputTextArea(
                  title: 'Location Description',
                  textEditingController: locationDescriptionController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SelectLocationPage())).then((value) {
                        LatLng position = value as LatLng;
                        longitude = value.longitude.toString();
                        latitude = value.latitude.toString();
                      });
                    },
                    child: const Text('Select Location')),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: Container(
                    width: 180,
                    height: 100,
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
                const Spacer(),
                InputTextButton(
                  title: "Update",
                  onClick: () {
                    print(_image);
                    if (_formKey.currentState!.validate()) {
                      storeController.updateStore(
                        id: store.id,
                        store_name: storeNameController.text,
                        image: _image,
                        store_description: storeDescriptionController.text,
                        location_description:
                            locationDescriptionController.text,
                        longitude: longitude,
                        latitude: latitude,
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
                const SizedBox(height: 10)
              ],
            ),
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
          storeNameController.text = store.store_name;
          storeNameController.text = store.store_name;
          storeDescriptionController.text = store.store_description;
          locationDescriptionController.text = store.location_description;
          _image = store.image as File?;
          longitude = store.longitude;
          latitude = store.latitude;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
