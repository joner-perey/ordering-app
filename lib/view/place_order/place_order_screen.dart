import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lalaco/component/input_dropdown_button.dart';
import 'package:lalaco/component/input_outline_button.dart';
import 'package:lalaco/component/input_text_area.dart';
import 'package:lalaco/component/input_text_button.dart';
import 'package:lalaco/component/input_text_field.dart';
import 'package:lalaco/const.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/extension/string_extension.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/category.dart';
import 'package:lalaco/model/store.dart';

import 'package:image_picker/image_picker.dart';
import 'package:lalaco/view/order/order_screen.dart';
import 'package:lalaco/view/place_order/build_delivery.dart';
import 'package:lalaco/view/select_location/select_location.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreen();
}

class _PlaceOrderScreen extends State<PlaceOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController orderNoteController = TextEditingController();
  TextEditingController deliveryAddressController = TextEditingController();
  TextEditingController deliveryPositionController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();

  String? selectedOrderType;
  String? deliveryAddress;

  late LatLng addressPosition = LatLng(0, 0);

  @override
  void dispose() {
    orderNoteController.dispose();
    deliveryAddressController.dispose();
    deliveryPositionController.dispose();
    super.dispose();
  }

  void updateDeliveryAddress(String address) {
    setState(() {
      deliveryAddress = address;
    });
  }

  void updateSelectedPosition(LatLng position) {
    setState(() {
      addressPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Place Order",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Fill up Order Information",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  InputDropdownButton(
                    title: 'Order Type',
                    items: const ['Pick-up', 'Delivery'],
                    value: selectedOrderType,
                    onChanged: (value) {
                      setState(() {
                        selectedOrderType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  OrderTypeWidget(
                    selectedOrderType: selectedOrderType,
                    deliveryAddressController: deliveryAddressController,
                    deliveryPositionController: deliveryPositionController,
                    onUpdateDeliveryAddress: updateDeliveryAddress,
                    onUpdateSelectedPosition: updateSelectedPosition,
                  ),
                  const SizedBox(height: 10),
                  InputTextField(
                    title: 'Mobile No.',
                    textEditingController: mobileNoController,
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
                  InputTextArea(
                    title: 'Note',
                    textEditingController: orderNoteController,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 350,
                    child: Column(
                      children: List<Widget>.generate(
                        cartItemsController.cartItemList.length,
                        (index) {
                          final cartItem =
                              cartItemsController.cartItemList[index];
                          final image = cartItem.product.image;
                          final name = cartItem.product.name;
                          final price = cartItem.product.price.toString();
                          final quantity = cartItem.quantity.toString();
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Image.network(
                                          '$baseUrl/storage/uploads/$image',
                                          width: 70,
                                          height: 72,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Product: $name',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Quantity: $quantity' + 'x',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Price: Php$price',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (index !=
                                  cartItemsController.cartItemList.length - 1)
                                const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InputTextButton(
                    title: "Checkout",
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        orderController.addOrder(
                            user_id: authController.user.value!.id,
                            store_id: cartItemsController
                                .cartItemList[0].store_id
                                .toString(),
                            address: deliveryAddress.toString(),
                            phone_number: mobileNoController.text,
                            longitude: addressPosition.longitude.toString(),
                            latitude: addressPosition.latitude.toString(),
                            type: selectedOrderType.toString(),
                            status: 'Pending');

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderScreen()));
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
