// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmaco_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FarmacoModelAdapter extends TypeAdapter<FarmacoModel> {
  @override
  final int typeId = 2;

  @override
  FarmacoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FarmacoModel(
      nome: fields[0] as String,
      dose: fields[1] as String,
      formaTerapeutica: fields[2] as String,
      orario: fields[3] as String,
      frequenza: fields[4] as String,
      assunto: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, FarmacoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.dose)
      ..writeByte(2)
      ..write(obj.formaTerapeutica)
      ..writeByte(3)
      ..write(obj.orario)
      ..writeByte(4)
      ..write(obj.frequenza)
      ..writeByte(5)
      ..write(obj.assunto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FarmacoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
