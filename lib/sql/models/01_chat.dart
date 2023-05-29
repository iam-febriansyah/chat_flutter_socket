// ignore_for_file: file_names

import 'package:hive/hive.dart';

part '01_chat.g.dart';

@HiveType(typeId: 0)
class SqlChat extends HiveObject {
  @HiveField(0)
  final String chatId;

  @HiveField(1)
  final String fromUserId;

  @HiveField(2)
  final String toUserId;

  @HiveField(3)
  final String message;

  @HiveField(4)
  final String file;

  @HiveField(5)
  final String createdAt;

  @HiveField(6)
  final String timeZone;

  @HiveField(7)
  final String readAt;

  @HiveField(8)
  final String createdAtServer;

  @HiveField(9)
  final String isMe;

  SqlChat({
    required this.chatId,
    required this.fromUserId,
    required this.toUserId,
    required this.message,
    required this.file,
    required this.createdAt,
    required this.timeZone,
    required this.readAt,
    required this.createdAtServer,
    required this.isMe,
  });
}
