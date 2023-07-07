import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/schedule.dart';
import 'package:lalaco/view/schedule/schedule_form.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {

  @override
  void initState() {
    fetchSchedules();
    super.initState();
  }

  void fetchSchedules() async {
    await scheduleController.getSchedules(storeId: authController.store.value!.id);

    setState(() {

    });
  }

  String displayTime(Schedule schedule) {
    var arrStartTime = schedule.start_time.split(':');
    var arrEndTime = schedule.end_time.split(':');

    TimeOfDay startTime = TimeOfDay(hour: int.parse(arrStartTime[0]), minute: int.parse(arrStartTime[1]));
    TimeOfDay endTime = TimeOfDay(hour: int.parse(arrEndTime[0]), minute: int.parse(arrEndTime[1]));

    return '${startTime.format(context)} - ${endTime.format(context)}';
  }

  String displayDays(Schedule schedule) {
    List<dynamic> days = jsonDecode(schedule.days);
    List<String> daysStr = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    String converted = '';
    bool everyday = true;

    for (int i = 0; i< days.length; i++) {
      if (days[i]) {
        converted += daysStr[i];
        converted += ' ';
      } else {
        everyday = false;
      }
    }

    if (everyday) {
      return 'Everyday';
    }

    return converted;
  }

  void handleDelete(int schedule_id) async {
    await scheduleController.deleteSchedule(schedule_id: schedule_id);
    fetchSchedules();
  }

  showDeleteDialog(BuildContext context, int schedule_id) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes",
      style: TextStyle(
        color: Colors.black54
      )),
      onPressed: () {
        handleDelete(schedule_id);
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(
          color: Colors.black54
      )),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Schedule"),
      content: const Text("Do you want to delete the schedule?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
      Scaffold(
        appBar: AppBar(
          title: const Text('Schedule'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: scheduleController.scheduleList.length == 0 ? Center(child: const Text('You Have No Schedule', style: TextStyle(
                fontSize: 18,
                color: Colors.black54
              ),)) : Column(
                children: List<Widget>.generate(
                  scheduleController.scheduleList.length,
                      (index) {
                    final schedule = scheduleController.scheduleList[index];


                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Column(
                              //   children: [
                              //     Image.network(
                              //       '$baseUrl/storage/uploads/$image',
                              //       width: 90,
                              //       height: 100,
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ],
                              // ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        'Location: ${schedule.location_description}',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Days: ${displayDays(schedule)}',
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 18
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Time: ${displayTime(schedule)}',
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 18
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          ElevatedButton(onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ScheduleForm(schedule: schedule,))).then((value) {
                                              fetchSchedules();
                                            });
                                          }, child: Text('Edit')),
                                          SizedBox(width: 8),
                                          ElevatedButton(onPressed: () {
                                            showDeleteDialog(context, schedule.id);
                                          }, child: Text('Delete')),
                                          // IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                                          // IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.start,
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScheduleForm(schedule: null,))).then((value) {
              fetchSchedules();
            });
          },
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      )
    );
  }


}
