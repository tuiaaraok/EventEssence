import 'package:hive_flutter/hive_flutter.dart';

part 'contact_model.g.dart';

@HiveType(typeId: 3)
class ContactModel {
  @HiveField(0)
  String name;
  @HiveField(1)
  String phone;
  @HiveField(2)
  String mail;
  ContactModel({required this.name, required this.mail, required this.phone});
}
