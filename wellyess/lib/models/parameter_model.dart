import 'package:hive/hive.dart';

part 'parameter_model.g.dart';

@HiveType(typeId: 4)
class ParameterEntry {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final int sys;

  @HiveField(2)
  final int dia;

  @HiveField(3)
  final int bpm;

  @HiveField(4)
  final int hgt;

  @HiveField(5)
  final int spo2;

  ParameterEntry({
    required this.timestamp,
    required this.sys,
    required this.dia,
    required this.bpm,
    required this.hgt,
    required this.spo2,
  });
}