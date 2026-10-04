import 'package:hive_ce/hive.dart';

part 'maintenance_record.g.dart';

/// A lightweight maintenance log entry.
@HiveType(typeId: 2)
class MaintenanceRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String motorcycleId;

  @HiveField(2)
  String title;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  double? mileageAtService;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  DateTime createdAt;

  MaintenanceRecord({
    required this.id,
    required this.motorcycleId,
    required this.title,
    required this.date,
    this.mileageAtService,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Creates a copy with updated fields.
  MaintenanceRecord copyWith({
    String? title,
    DateTime? date,
    double? mileageAtService,
    String? notes,
  }) {
    return MaintenanceRecord(
      id: id,
      motorcycleId: motorcycleId,
      title: title ?? this.title,
      date: date ?? this.date,
      mileageAtService: mileageAtService ?? this.mileageAtService,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }
}
