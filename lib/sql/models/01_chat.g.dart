// GENERATED CODE - DO NOT MODIFY BY HAND

part of '01_chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SqlChatAdapter extends TypeAdapter<SqlChat> {
  @override
  final int typeId = 0;

  @override
  SqlChat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SqlChat(
      chatId: fields[0] as String,
      fromUserId: fields[1] as String,
      toUserId: fields[2] as String,
      message: fields[3] as String,
      file: fields[4] as String,
      createdAt: fields[5] as String,
      timeZone: fields[6] as String,
      readAt: fields[7] as String,
      createdAtServer: fields[8] as String,
      isMe: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SqlChat obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.chatId)
      ..writeByte(1)
      ..write(obj.fromUserId)
      ..writeByte(2)
      ..write(obj.toUserId)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.file)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.timeZone)
      ..writeByte(7)
      ..write(obj.readAt)
      ..writeByte(8)
      ..write(obj.createdAtServer)
      ..writeByte(9)
      ..write(obj.isMe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
