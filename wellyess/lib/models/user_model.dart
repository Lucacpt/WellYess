import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
enum UserType {
  @HiveField(0)
  elder,
  @HiveField(1)
  caregiver,
}

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final UserType type;

  UserModel({
    required this.email,
    required this.type,
  });
}