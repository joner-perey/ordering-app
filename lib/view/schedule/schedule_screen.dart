import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lalaco/view/schedule/schedule_form.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
      Scaffold(
        appBar: AppBar(
          title: const Text('Schedule'),
        ),
        body: Text('Schedule'),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScheduleForm()));
          },
          backgroundColor: Colors.deepPurpleAccent,
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}
