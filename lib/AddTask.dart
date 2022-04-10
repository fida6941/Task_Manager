import 'package:flutter/material.dart';
import 'Task.dart';
import 'TaskPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Reminder.dart';

class AddTask extends StatefulWidget {

  TaskPageState task;

  AddTask(
      {Key? key,
        required this.task})
      : super(key: key);

  @override
  AddTaskState createState() => AddTaskState(task);
}

class AddTaskState extends State<AddTask> {

  TaskPageState task;
  AddTaskState(this.task);

  String newTitle = "Untitled";
  DateTime newDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool datePicked = false;
  bool timePicked = false;
  bool reminder = false;

  DateTime selectedDate = DateTime.now();
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        datePicked = true;
        selectedDate = picked;
      });
    print(selectedDate);
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        timePicked = true;
        selectedTime = pickedTime;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Task"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: "Untitled",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800]),
                  onChanged: (String text) {
                    newTitle = text;
                  },
                ),
                SizedBox(height: 80),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectDate(context);
                            });
                          },
                          child: Text(datePicked == true ?
                          "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}" : "Select Date for Reminder",
                            style: TextStyle(fontSize: 20),
                          )),
                      OutlinedButton(
                          onPressed: () {
                            selectTime(context);
                          },
                          child: Text(timePicked == true ? selectedTime.format(context) : "Select Time for Reminder",
                              style: TextStyle(
                                fontSize: 20,
                              ))),
                      SizedBox(height: 20),
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              if(datePicked == true && timePicked == true) {
                                reminder = true;
                              }
                            });
                          },
                          child: const Text("Set Reminder")),
                    ],
                  ),
                ),

                SizedBox(height: 180),
                Center(
                  child: TextButton(
                    onPressed: () {
                      task.addTask(
                          newTitle, reminder, selectedDate, selectedTime);
                      Navigator.pop(context);
                      setState(() {
                        if(reminder == true) {
                          ReminderState.showNotification(
                            title: newTitle,
                            body: "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}  " + selectedTime.format(context),
                            scheduledDate:
                            DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute),
                          );
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 12.0, bottom: 12.0, left: 18.0, right: 18.0),
                      color: Colors.blue[300],
                      child: Text("Save",
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
