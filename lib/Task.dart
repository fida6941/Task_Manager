import 'package:flutter/material.dart';

class Task {
  late String taskName;
  late bool isChecked;
  late bool reminderSet;
  late DateTime reminderDate;
  late TimeOfDay reminderTime;

  Task(this.taskName, this.isChecked, this.reminderSet, this.reminderDate, this.reminderTime);

  Task.fromJson(Map<String, dynamic> json)
      : taskName = json['taskName'],
        isChecked = json['isChecked'],
  reminderSet = json['reminderSet'],
  reminderDate =  DateTime.parse(json['reminderDate']),
  reminderTime = TimeOfDay(hour:int.parse(json['eventTime'].split(":")[0]),minute: int.parse(json['eventTime'].split(":")[1]));

  Map<String, dynamic> toJson() => {
    'taskName': taskName,
    'isChecked': isChecked,
    'reminderSet': reminderSet,
    'reminderDate': reminderDate.toIso8601String(),
    'reminderTime': reminderTime.toString(),
  };
}
