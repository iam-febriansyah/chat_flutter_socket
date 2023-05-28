class Chat {
  String chatId;
  String fromUserId;
  String toUserId;
  String message;
  String isMe;
  String? file;
  String createdAt;
  String timeZone;
  String? readAt;
  String? deletedAt;
  String createdAtServer;
  String? deletedAtServer;

  Chat({
    required this.chatId,
    required this.fromUserId,
    required this.toUserId,
    required this.message,
    required this.isMe,
    this.file,
    required this.createdAt,
    required this.timeZone,
    this.readAt,
    this.deletedAt,
    required this.createdAtServer,
    this.deletedAtServer,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chatId: json["chat_id"],
        fromUserId: json["from_user_id"],
        toUserId: json["to_user_id"],
        message: json["message"],
        file: json["file"] ?? '',
        createdAt: json["created_at"],
        isMe: json["is_me"],
        timeZone: json["time_zone"],
        readAt: json["read_at"] ?? '',
        deletedAt: json["deleted_at"] ?? '',
        createdAtServer: json["created_at_server"],
        deletedAtServer: json["deleted_at_server"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "from_user_id": fromUserId,
        "to_user_id": toUserId,
        "message": message,
        "file": file,
        "created_at": createdAt,
        "time_zone": timeZone,
        "read_at": readAt,
        "deleted_at": deletedAt,
        "created_at_server": createdAtServer,
        "deleted_at_server": deletedAtServer,
      };
}
