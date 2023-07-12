import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lalaco/component/input_text_area.dart';
import 'package:lalaco/view/select_location/select_location.dart';

class OrderTypeWidget extends StatefulWidget {
  final String? selectedOrderType;
  final TextEditingController deliveryAddressController;
  final TextEditingController deliveryPositionController;
  final Function(String) onUpdateDeliveryAddress;
  final Function(LatLng) onUpdateSelectedPosition;

  const OrderTypeWidget({
    required this.selectedOrderType,
    required this.deliveryAddressController,
    required this.deliveryPositionController,
    required this.onUpdateDeliveryAddress,
    required this.onUpdateSelectedPosition,
  });

  @override
  _OrderTypeWidgetState createState() => _OrderTypeWidgetState();
}

class _OrderTypeWidgetState extends State<OrderTypeWidget> {
  @override
  void initState() {
    super.initState();
    widget.deliveryAddressController.addListener(_handleDeliveryAddressChange);
  }

  @override
  void dispose() {
    widget.deliveryAddressController
        .removeListener(_handleDeliveryAddressChange);
    super.dispose();
  }

  void _handleDeliveryAddressChange() {
    widget.onUpdateDeliveryAddress(widget.deliveryAddressController.text);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedOrderType == 'Delivery') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputTextArea(
            textEditingController: widget.deliveryAddressController,
            title: 'Address',
            validation: (String? value) {
              if (value == null || value.isEmpty) {
                return "This field can't be empty";
              }
              return null;
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectLocationPage()))
                    .then((value) {
                  LatLng position = value as LatLng;
                  widget.onUpdateSelectedPosition(value);
                  // SnackBar snackBar = SnackBar(
                  //   content: Text(
                  //       'latitude: ${position.latitude}, longitude: ${position.longitude}'),
                  // );

                  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: const Text('Select Location')),
        ],
      );
    } else {
      return Container(); // Return an empty container if 'Delivery' is not selected
    }
  }
}
