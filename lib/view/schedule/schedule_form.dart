import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lalaco/component/input_text_field.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/schedule.dart';

import '../../component/input_text_button.dart';
import '../select_location/select_location.dart';

class ScheduleForm extends StatefulWidget {
  final Schedule? schedule;

  const ScheduleForm({required this.schedule});

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController locationDescriptionController = TextEditingController();

  LatLng? addressPosition;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  List<bool> days = [false, false, false, false, false, false, false];


  @override
  void initState() {
    if (widget.schedule != null) {
      var arrStartTime = widget.schedule!.start_time.split(':');
      var arrEndTime = widget.schedule!.end_time.split(':');

      startTime = TimeOfDay(hour: int.parse(arrStartTime[0]), minute: int.parse(arrStartTime[1]));
      endTime = TimeOfDay(hour: int.parse(arrEndTime[0]), minute: int.parse(arrEndTime[1]));
      locationDescriptionController.text = widget.schedule!.location_description;
      addressPosition = LatLng(double.parse(widget.schedule!.latitude), double.parse(widget.schedule!.longitude));
      days = List<bool>.from(jsonDecode(widget.schedule!.days) as List);
    }


    super.initState();
  }

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

  bool validate() {
    bool hasSelectedDays = false;

    for (var i = 0 ; i < days.length; i++) {
      if (days[i]) {
        hasSelectedDays = true;
        break;
      }
    }

    if (addressPosition == null) {
      EasyLoading.showError('Please Select Location');
      return false;
    }

    if (startTime == null) {
      EasyLoading.showError('Please Select Start Time');
      return false;
    }

    if (endTime == null) {
      EasyLoading.showError('Please Select End Time');
      return false;
    }




    if (!hasSelectedDays) {
      EasyLoading.showError('Please Select Day');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      appBar: AppBar(
        title: Text(widget.schedule == null ? 'Add Schedule' : 'Edit Schedule'),
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
              Text(
                widget.schedule == null ? 'Add Schedule' : 'Edit Schedule',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.schedule == null ? "Fill Schedule Information" : "Edit Schedule Information",
                style: const TextStyle(
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
              Text(addressPosition != null ? "Latitude: ${addressPosition!.latitude}, Longitude: ${addressPosition!.longitude}" : "",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),),
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
              const SizedBox(height: 10),
              const Text(
                "Select Days",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              Column(
                children: <Widget>[
                  CheckboxListTile(
                    value: days[0],
                    onChanged: (bool? value) {
                      setState(() {
                        days[0] = value!;
                      });
                    },
                    title: const Text('Monday'),
                  ),
                  const Divider(height: 0),
                  CheckboxListTile(
                    value: days[1],
                    onChanged: (bool? value) {
                      setState(() {
                        days[1] = value!;
                      });
                    },
                    title: const Text('Tuesday'),
                  ),
                  const Divider(height: 0),
                  CheckboxListTile(
                    value: days[2],
                    onChanged: (bool? value) {
                      setState(() {
                        days[2] = value!;
                      });
                    },
                    title: const Text('Wednesday'),
                  ),
                  const Divider(height: 0),
                  CheckboxListTile(
                    value: days[3],
                    onChanged: (bool? value) {
                      setState(() {
                        days[3] = value!;
                      });
                    },
                    title: const Text('Thursday'),
                  ),
                  const Divider(height: 0),
                  CheckboxListTile(
                    value: days[4],
                    onChanged: (bool? value) {
                      setState(() {
                        days[4] = value!;
                      });
                    },
                    title: const Text('Friday'),
                  ),
                  const Divider(height: 0),
                  CheckboxListTile(
                    value: days[5],
                    onChanged: (bool? value) {
                      setState(() {
                        days[5] = value!;
                      });
                    },
                    title: const Text('Saturday'),
                  ),
                  const Divider(height: 0),
                  CheckboxListTile(
                    value: days[6],
                    onChanged: (bool? value) {
                      setState(() {
                        days[6] = value!;
                      });
                    },
                    title: const Text('Sunday'),
                  ),
                  const Divider(height: 0),
                ],
              ),
              InputTextButton(
                title: widget.schedule == null ? "Add" : "Update",
                onClick: () {
                  if (_formKey.currentState!.validate()) {
                    bool isValid = validate();

                    if (!isValid) {
                      return;
                    }

                    String formattedStartTime = '${startTime?.hour.toString().padLeft(2, '0')}:${startTime?.minute.toString().padLeft(2, '0')}';
                    String formattedEndTime = '${endTime?.hour.toString().padLeft(2, '0')}:${endTime?.minute.toString().padLeft(2, '0')}';

                    if (widget.schedule == null) {
                      scheduleController.addSchedule(
                          store_id: authController.store.value!.id.toString(),
                          location_description: locationDescriptionController.text,
                          start_time: formattedStartTime,
                          end_time: formattedEndTime,
                          longitude: addressPosition!.longitude.toString(),
                          latitude: addressPosition!.latitude.toString(),
                          days: jsonEncode(days));
                    } else {
                      scheduleController.updateSchedule(
                          schedule_id: widget.schedule!.id,
                          store_id: authController.store.value!.id.toString(),
                          location_description: locationDescriptionController.text,
                          start_time: formattedStartTime,
                          end_time: formattedEndTime,
                          longitude: addressPosition!.longitude.toString(),
                          latitude: addressPosition!.latitude.toString(),
                          days: jsonEncode(days));
                    }

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
