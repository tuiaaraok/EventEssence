import 'package:hive_flutter/hive_flutter.dart';
part 'task_model.g.dart';

@HiveType(typeId: 2)
class TaskModel {
  @HiveField(0)
  String selectAnEvent;
  @HiveField(1)
  String taskName;
  @HiveField(2)
  String startTime;
  @HiveField(3)
  String endTime;
  @HiveField(4)
  String assignResponsiblePerson;
  @HiveField(5)
  String setDeadline;
  TaskModel(
      {required this.selectAnEvent,
      required this.taskName,
      required this.startTime,
      required this.endTime,
      required this.assignResponsiblePerson,
      required this.setDeadline});
}
