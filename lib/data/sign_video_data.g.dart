// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_video_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SignVideoDataAdapter extends TypeAdapter<SignVideoData> {
  @override
  final int typeId = 108;

  @override
  SignVideoData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SignVideoData(
      videoUrl: fields[0] as String?,
      videoPath: fields[1] as String,
      status: fields[2] as bool?,
      contentData: (fields[3] as List?)?.cast<SignContentData>(),
    );
  }

  @override
  void write(BinaryWriter writer, SignVideoData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.videoUrl)
      ..writeByte(1)
      ..write(obj.videoPath)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.contentData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignVideoDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SignContentDataAdapter extends TypeAdapter<SignContentData> {
  @override
  final int typeId = 109;

  @override
  SignContentData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SignContentData(
      content: fields[4] as String?,
      startTime: fields[0] as double?,
      endTime: fields[1] as double?,
      videoUrl: fields[2] as String?,
      videoDuration: fields[3] as double?,
      q: fields[5] as int?,
      fileGifPath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SignContentData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.videoUrl)
      ..writeByte(3)
      ..write(obj.videoDuration)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.q)
      ..writeByte(6)
      ..write(obj.fileGifPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignContentDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
