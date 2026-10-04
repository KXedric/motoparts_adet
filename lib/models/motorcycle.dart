import 'package:hive_ce/hive.dart';

part 'motorcycle.g.dart';

/// Represents a motorcycle tracked by the user.
@HiveType(typeId: 0)
class Motorcycle extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String model;

  @HiveField(2)
  int year;

  @HiveField(3)
  String engineDisplacement;

  @HiveField(4)
  String? licensePlate;

  @HiveField(5)
  double mileage;

  @HiveField(6)
  String? imageUrl;

  @HiveField(7)
  Map<String, String> specs;

  Motorcycle({
    required this.id,
    required this.model,
    required this.year,
    this.engineDisplacement = '',
    this.licensePlate,
    this.mileage = 0,
    this.imageUrl,
    Map<String, String>? specs,
  }) : specs = specs ?? {};

  /// Creates a copy with updated fields.
  Motorcycle copyWith({
    String? model,
    int? year,
    String? engineDisplacement,
    String? licensePlate,
    double? mileage,
    String? imageUrl,
    Map<String, String>? specs,
  }) {
    return Motorcycle(
      id: id,
      model: model ?? this.model,
      year: year ?? this.year,
      engineDisplacement: engineDisplacement ?? this.engineDisplacement,
      licensePlate: licensePlate ?? this.licensePlate,
      mileage: mileage ?? this.mileage,
      imageUrl: imageUrl ?? this.imageUrl,
      specs: specs ?? Map.from(this.specs),
    );
  }
}
