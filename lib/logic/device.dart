import 'package:hive/hive.dart';

part 'device.g.dart';

@HiveType(typeId: 3)
class Device {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String os;

  @HiveField(2)
  String name;

  @HiveField(3)
  bool isOnline;

  @HiveField(4)
  String ip;

  @HiveField(5)
  String url;

  Device({required this.id, required this.name, required this.isOnline, required this.os, required this.ip, required this.url});
}
