import 'package:hive/hive.dart';

part '02_user.g.dart';

@HiveType(typeId: 1)
class SqlUser extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String email;

  @HiveField(2)
  String isOnline;

  @HiveField(3)
  String fullname;

  @HiveField(4)
  String status;

  SqlUser({required this.userId, required this.email, required this.isOnline, required this.fullname, required this.status});
}
