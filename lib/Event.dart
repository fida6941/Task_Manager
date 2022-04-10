import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
class Event {
  late String eventTitle;
  late DateTime eventDate;
  late TimeOfDay eventTime;

  Event(this.eventTitle, this.eventDate, this.eventTime);

  Event.fromJson(Map<String, dynamic> json)
      : eventTitle = json['eventTitle'],
        eventDate = DateTime.parse(json['eventDate']),
        eventTime = TimeOfDay(hour:int.parse(json['eventTime'].split(":")[0]),minute: int.parse(json['eventTime'].split(":")[1]));

  Map<String, dynamic> toJson() => {
    'eventTitle': eventTitle,
    'eventDate': eventDate.toString(),
    'eventTime': eventTime.toString(),
  };
}
