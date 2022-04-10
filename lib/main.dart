import 'package:flutter/material.dart';
import 'package:task_manager/Event.dart';
import 'package:task_manager/TaskPage.dart';
import 'AddEvent.dart';
import 'EditEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
      });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.black54,
      ),
      home: const MyHomePage(title: 'Task Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => EventPage();
}

class EventPage extends State<MyHomePage> {
  // List<Event> events = [
  //   Event("Quiz", DateTime(2021, 10, 28), TimeOfDay(hour: 9, minute: 0))
  // ];
  List<Event> events = [];
  static bool eventsSelected = true;

  void editEvent(
      int index, String newTitle, DateTime newDate, TimeOfDay newTime) {
    setState(() {
      if (newTitle != "") {
        events[index].eventTitle = newTitle;
      }
      events[index].eventDate = newDate;
      events[index].eventTime = newTime;
    });
    saveFile();
  }

  void addEvent(String newTitle, DateTime newDate, TimeOfDay newTime) {
    setState(() {
      events.add(Event(newTitle, newDate, newTime));
    });
    saveFile();
  }

  saveFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("events", jsonEncode(events));
  }

  readFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<dynamic> mappedList = jsonDecode(prefs.getString("events")!);
      for (var index in mappedList) {
        String eventTitle = index["eventTitle"];
        DateTime eventDate = DateTime.parse(index["eventDate"]);
        String eventTime = index["eventTime"].substring(10, 15);
        TimeOfDay time = TimeOfDay(hour: int.parse(eventTime.split(":")[0]), minute: int.parse(eventTime.split(":")[1]));
        events.add(Event(eventTitle, eventDate, time));
      }
    });
  }

  @override
  void initState() {
    readFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    saveFile();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: ListView.builder(
                itemCount: events.length,
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
                            Text(
                              events[index].eventTitle,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditEvent(
                                          events: events,
                                          index: index,
                                          event: this,
                                        ),
                                      ));
                                },
                                icon: Icon(Icons.edit, color: Colors.white,)),
                            IconButton(onPressed: () {
                              setState(() {
                                events.removeAt(index);
                              });
                            }, icon: Icon(Icons.delete, color: Colors.white))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${events[index].eventDate.month}/${events[index].eventDate.day}/${events[index].eventDate.year}",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            SizedBox(width: 15),
                            Text(
                              events[index].eventTime.format(context),
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
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
                  color: Colors.blueGrey,
                  child: TextButton(
                      onPressed: () {},
                      child: Text("Events",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w800))),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                  color: Colors.blueGrey.withOpacity(0.6),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          eventsSelected = false;
                        });
                        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => TaskPage(),
                          transitionDuration: Duration.zero,),);
                      },
                      child: Text("Tasks",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
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
                  builder: (context) => AddEvent(event: this),
                ));
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
