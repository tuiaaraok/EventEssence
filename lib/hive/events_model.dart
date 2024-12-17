import 'package:event_management/hive/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'events_model.g.dart';

@HiveType(typeId: 1)
class EventsModel {
  @HiveField(0)
  String eventName;
  @HiveField(1)
  String startDate;
  @HiveField(2)
  String endDate;
  @HiveField(3)
  String startTime;
  @HiveField(4)
  String endTime;
  @HiveField(5)
  String location;
  @HiveField(6)
  String description;
  @HiveField(7)
  List<String> contacts;
  @HiveField(8)
  List<TaskModel>? tasks;
  EventsModel(
      {required this.eventName,
      required this.startDate,
      required this.endDate,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.description,
      required this.contacts,
      this.tasks});
}
