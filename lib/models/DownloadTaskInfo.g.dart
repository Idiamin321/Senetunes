// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DownloadTaskInfo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadTaskInfoAdapter extends TypeAdapter<DownloadTaskInfo> {
  @override
  final int typeId = 0;

  @override
  DownloadTaskInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadTaskInfo(
      track: fields[0] as Track,
    )
      ..received = fields[1] as int
      ..total = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, DownloadTaskInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.track)
      ..writeByte(1)
      ..write(obj.received)
      ..writeByte(2)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadTaskInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
