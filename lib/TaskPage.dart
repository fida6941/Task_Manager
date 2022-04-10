import 'package:flutter/material.dart';
import 'Event.dart';
import 'main.dart';
import 'Task.dart';
import 'EditTask.dart';
import 'AddTask.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskPage extends StatefulWidget {
  TaskPage({Key? key}) : super(key: key);

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  Duration get transitionDuration => const Duration(milliseconds: 0);

  //List<Task> tasks = [Task("New Task", false, false, DateTime.now(), TimeOfDay.now())];
  List<Task> tasks = [];

  void editTask(
      int index, String newTitle, bool reminder, DateTime newDate, TimeOfDay newTime) {
    setState(() {
      if (newTitle != "") {
        tasks[index].taskName = newTitle;
      }
      tasks[index].reminderSet = reminder;
      tasks[index].reminderDate = newDate;
      tasks[index].reminderTime = newTime;
      print(tasks[index].reminderSet);
      print(tasks[index].reminderDate);
      print(tasks[index].reminderTime);
    });
  }

  void addTask(String newTitle, bool reminder, DateTime newDate, TimeOfDay newTime) {
    setState(() {
      tasks.add(Task(newTitle, false, reminder, newDate, newTime));
    });
  }

  saveFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("tasks", jsonEncode(tasks));
  }

  readFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<dynamic> mappedList = jsonDecode(prefs.getString("tasks")!);
      for (var index in mappedList) {
        DateTime reminderDate = DateTime.parse(index["reminderDate"]);
        String reminderTime = index["reminderTime"].substring(10, 15);
        TimeOfDay time = TimeOfDay(hour: int.parse(reminderTime.split(":")[0]), minute: int.parse(reminderTime.split(":")[1]));
        tasks.add(Task(index["taskName"], index["isChecked"], index["reminderSet"], reminderDate, time));
      }
    });
  }

  @override
  void initState() {
    readFile();
    super.initState();
  }


  @override
  Widget build(BuildContext Context) {
    saveFile();
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: ListView.builder(
                itemCount: tasks.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.blueGrey.withOpacity(0.6)),
                    padding: EdgeInsets.all(15.0),
                    margin: EdgeInsets.all(20.0),
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(value: tasks[index].isChecked, onChanged: (bool? value){
                              setState(() {
                                tasks[index].isChecked = value!;
                              });
                            }),
                            Text(
                              tasks[index].taskName,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditTask(
                                          tasks: tasks,
                                          index: index,
                                          task: this,
                                        ),
                                      ));
                                },
                                icon: Icon(Icons.edit, color: Colors.white,)),
                            IconButton(onPressed: () {
                              setState(() {
                                tasks.removeAt(index);
                              });
                            }, icon: Icon(Icons.delete, color: Colors.white,))
                          ],
                        ),
                        Visibility(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Row(
                              children: [
                                Text(
                                  "${tasks[index].reminderDate.month}/${tasks[index].reminderDate.day}/${tasks[index].reminderDate.year}",
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  tasks[index].reminderTime.format(context),
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.alarm),
                              ],
                            ),
                          ),
                          visible: tasks[index].reminderSet == true ? true : false,
                        ),
                      ],
                    ),
                  );
                }),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                  color: Colors.blueGrey.withOpacity(0.6),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          EventPage.eventsSelected = true;
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Events",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                  color: Colors.blueGrey,
                  child: TextButton(
                      onPressed: () {},
                      child: Text("Tasks",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w800))),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTask(task: this),
                ));
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
