import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lalaco/component/input_text_field.dart';
import 'package:lalaco/controller/controllers.dart';

import '../../component/input_text_button.dart';
import '../select_location/select_location.dart';

class ScheduleForm extends StatefulWidget {
  const ScheduleForm({Key? key}) : super(key: key);

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController locationDescriptionController = TextEditingController();

  LatLng? addressPosition;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void dispose() {
    locationDescriptionController.dispose();
    super.dispose();
  }

  void updateSelectedPosition(LatLng position) {
    setState(() {
      addressPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Add Schedule",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Fill Schedule Information",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectLocationPage()))
                    .then((value) {
                  LatLng position = value as LatLng;
                  updateSelectedPosition(position);
                  SnackBar snackBar = SnackBar(
                    content: Text(
                        'latitude: ${position.latitude}, longitude: ${position.longitude}'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
                child: const Text('Select Location'),
              ),
              const SizedBox(height: 10),
              InputTextField(
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
              Row(
                children: [
                  ElevatedButton(onPressed: () async {
                    var selectedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            // button colors
                            buttonTheme: const ButtonThemeData(
                              colorScheme: ColorScheme.light(
                                primary: Colors.black,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    setState(() {
                      startTime = selectedTime;
                    });
                  }, child: const Text('Pick Start Time')),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(startTime == null ? '' : startTime!.format(context),
                      style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                    ),),
                  )
                ],
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: () async {
                    var selectedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            // button colors
                            buttonTheme: const ButtonThemeData(
                              colorScheme: ColorScheme.light(
                                primary: Colors.black,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    setState(() {
                      endTime = selectedTime;
                    });
                  }, child: const Text('Pick End Time')),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(endTime == null ? '' : endTime!.format(context),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),),
                  )
                ],
              ),
              InputTextButton(
                title: "Add",
                onClick: () {
                  if (_formKey.currentState!.validate()) {
                    String formattedStartTime = '${startTime?.hour.toString().padLeft(2, '0')}:${startTime?.minute.toString().padLeft(2, '0')}';
                    String formattedEndTime = '${endTime?.hour.toString().padLeft(2, '0')}:${endTime?.minute.toString().padLeft(2, '0')}';

                    scheduleController.addSchedule(
                        store_id: '1',
                        location_description: locationDescriptionController.text,
                        start_time: formattedStartTime,
                        end_time: formattedEndTime,
                        longitude: addressPosition!.longitude.toString(),
                        latitude: addressPosition!.latitude.toString(),
                        days: 'M');
                    // orderController.addOrder(
                    //     user_id: authController.user.value!.id,
                    //     store_id: cartItemsController
                    //         .cartItemList[0].store_id
                    //         .toString(),
                    //     address: deliveryAddress.toString(),
                    //     phone_number: mobileNoController.text,
                    //     longitude: addressPosition.longitude.toString(),
                    //     latitude: addressPosition.latitude.toString(),
                    //     type: selectedOrderType.toString(),
                    //     status: 'Preparing');
                    // print(deliveryAddress);
                    // print(addressPosition.toString());
                    // print(orderNoteController.text);
                    // print(authController.user.value?.id);
                    // print(cartItemsController.cartItemList[0].store_id);
                  }
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      )
    )
    );
  }
}
