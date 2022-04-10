import 'package:flutter/material.dart';
import 'Event.dart';
import 'main.dart';
import 'Reminder.dart';

class AddEvent extends StatefulWidget {
  EventPage event;

  AddEvent({Key? key, required this.event}) : super(key: key);

  @override
  AddEventState createState() => AddEventState(event);
}

class AddEventState extends State<AddEvent> {
  List<Event> events = <Event>[];
  late EventPage event;
  AddEventState(this.event);

  String newTitle = "Untitled";
  DateTime newDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool reminderSet = false;

  DateTime selectedDate = DateTime.now();
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
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
        selectedTime = pickedTime;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Event"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectDate(context);
                          });
                        },
                        child: Text(
                          "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}",
                          style: TextStyle(fontSize: 20),
                        )),
                    OutlinedButton(
                        onPressed: () {
                          selectTime(context);
                        },
                        child: Text(selectedTime.format(context),
                            style: TextStyle(
                              fontSize: 20,
                            ))),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: OutlinedButton(
                      onPressed: () {
                        reminderSet = true;
                      },
                      child: const Text("Set Reminder")),
                ),
                SizedBox(height: 180),
                Center(
                  child: TextButton(
                    onPressed: () {
                      event.addEvent(newTitle, selectedDate, selectedTime);
                      Navigator.pop(context);
                      setState(() {
                        if(reminderSet == true) {
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
