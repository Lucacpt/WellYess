// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameter_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParameterEntryAdapter extends TypeAdapter<ParameterEntry> {
  @override
  final int typeId = 4;

  @override
  ParameterEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParameterEntry(
      timestamp: fields[0] as DateTime,
      sys: fields[1] as int,
      dia: fields[2] as int,
      bpm: fields[3] as int,
      hgt: fields[4] as int,
      spo2: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ParameterEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.sys)
      ..writeByte(2)
      ..write(obj.dia)
      ..writeByte(3)
      ..write(obj.bpm)
      ..writeByte(4)
      ..write(obj.hgt)
      ..writeByte(5)
      ..write(obj.spo2);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParameterEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
