// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventsModelAdapter extends TypeAdapter<EventsModel> {
  @override
  final int typeId = 1;

  @override
  EventsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventsModel(
      eventName: fields[0] as String,
      startDate: fields[1] as String,
      endDate: fields[2] as String,
      startTime: fields[3] as String,
      endTime: fields[4] as String,
      location: fields[5] as String,
      description: fields[6] as String,
      contacts: (fields[7] as List).cast<String>(),
      tasks: (fields[8] as List?)?.cast<TaskModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, EventsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.eventName)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.contacts)
      ..writeByte(8)
      ..write(obj.tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
