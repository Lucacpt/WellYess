import 'package:hive/hive.dart';

part 'appointment_model.g.dart';

@HiveType(typeId: 3) // cambiato da 2 a 3
class AppointmentModel extends HiveObject {
  @HiveField(0)
  final String tipoVisita;
  @HiveField(1)
  final String luogo;
  @HiveField(2)
  final DateTime data;
  @HiveField(3)
  final DateTime ora;
  @HiveField(4)
  final String note;

  AppointmentModel({
    required this.tipoVisita,
    required this.luogo,
    required this.data,
    required this.ora,
    required this.note,
  });

  DateTime get dateTime {
    return DateTime(
      data.year,
      data.month,
      data.day,
      ora.hour,
      ora.minute,
    );
  }
}