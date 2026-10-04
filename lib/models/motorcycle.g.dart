// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motorcycle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MotorcycleAdapter extends TypeAdapter<Motorcycle> {
  @override
  final typeId = 0;

  @override
  Motorcycle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Motorcycle(
      id: fields[0] as String,
      model: fields[1] as String,
      year: (fields[2] as num).toInt(),
      engineDisplacement: fields[3] == null ? '' : fields[3] as String,
      licensePlate: fields[4] as String?,
      mileage: fields[5] == null ? 0 : (fields[5] as num).toDouble(),
      imageUrl: fields[6] as String?,
      specs: (fields[7] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Motorcycle obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.engineDisplacement)
      ..writeByte(4)
      ..write(obj.licensePlate)
      ..writeByte(5)
      ..write(obj.mileage)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.specs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotorcycleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
