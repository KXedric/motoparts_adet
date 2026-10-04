// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MotoPartAdapter extends TypeAdapter<MotoPart> {
  @override
  final typeId = 1;

  @override
  MotoPart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MotoPart(
      id: fields[0] as String,
      motorcycleId: fields[1] as String,
      name: fields[2] as String,
      category: fields[3] as String,
      brand: fields[4] as String?,
      modelNumber: fields[5] as String?,
      purchaseDate: fields[6] as DateTime?,
      purchasePrice: (fields[7] as num?)?.toDouble(),
      warrantyMonths: (fields[8] as num?)?.toInt(),
      warrantyExpiration: fields[9] as DateTime?,
      isInstalled: fields[10] == null ? true : fields[10] as bool,
      installationNotes: fields[11] as String?,
      torqueNotes: fields[12] as String?,
      preflightChecks: fields[13] as String?,
      imagePath: fields[14] as String?,
      createdAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MotoPart obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.motorcycleId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.brand)
      ..writeByte(5)
      ..write(obj.modelNumber)
      ..writeByte(6)
      ..write(obj.purchaseDate)
      ..writeByte(7)
      ..write(obj.purchasePrice)
      ..writeByte(8)
      ..write(obj.warrantyMonths)
      ..writeByte(9)
      ..write(obj.warrantyExpiration)
      ..writeByte(10)
      ..write(obj.isInstalled)
      ..writeByte(11)
      ..write(obj.installationNotes)
      ..writeByte(12)
      ..write(obj.torqueNotes)
      ..writeByte(13)
      ..write(obj.preflightChecks)
      ..writeByte(14)
      ..write(obj.imagePath)
      ..writeByte(15)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotoPartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
