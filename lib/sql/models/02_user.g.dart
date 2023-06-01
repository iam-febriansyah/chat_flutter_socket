// GENERATED CODE - DO NOT MODIFY BY HAND

part of '02_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SqlUserAdapter extends TypeAdapter<SqlUser> {
  @override
  final int typeId = 1;

  @override
  SqlUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SqlUser(
      userId: fields[0] as String,
      email: fields[1] as String,
      isOnline: fields[2] as String,
      fullname: fields[3] as String,
      status: fields[4] as String,
      color: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SqlUser obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.isOnline)
      ..writeByte(3)
      ..write(obj.fullname)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
