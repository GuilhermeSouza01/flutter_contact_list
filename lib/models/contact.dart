import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'contact.g.dart';

@HiveType(typeId: 0)
class ContactModel {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? phone;
  @HiveField(3)
  String? imageUrl;
  @HiveField(4)
  String? key;

  ContactModel(
      {@required this.name, this.email, this.phone, this.imageUrl, this.key});
}
