import 'package:hive_ce/hive.dart';

part 'part.g.dart';

/// Predefined part categories.
class PartCategory {
  PartCategory._();

  static const String engine = 'Engine';
  static const String exhaust = 'Exhaust';
  static const String brakes = 'Brakes';
  static const String tires = 'Tires';
  static const String suspension = 'Suspension';
  static const String electrical = 'Electrical';
  static const String other = 'Other';

  static const List<String> all = [
    engine,
    exhaust,
    brakes,
    tires,
    suspension,
    electrical,
    other,
  ];
}

/// Represents a motorcycle part record.
@HiveType(typeId: 1)
class MotoPart extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String motorcycleId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String category;

  @HiveField(4)
  String? brand;

  @HiveField(5)
  String? modelNumber;

  @HiveField(6)
  DateTime? purchaseDate;

  @HiveField(7)
  double? purchasePrice;

  @HiveField(8)
  int? warrantyMonths;

  @HiveField(9)
  DateTime? warrantyExpiration;

  @HiveField(10)
  bool isInstalled;

  @HiveField(11)
  String? installationNotes;

  @HiveField(12)
  String? torqueNotes;

  @HiveField(13)
  String? preflightChecks;

  @HiveField(14)
  String? imagePath;

  @HiveField(15)
  DateTime createdAt;

  MotoPart({
    required this.id,
    required this.motorcycleId,
    required this.name,
    required this.category,
    this.brand,
    this.modelNumber,
    this.purchaseDate,
    this.purchasePrice,
    this.warrantyMonths,
    this.warrantyExpiration,
    this.isInstalled = true,
    this.installationNotes,
    this.torqueNotes,
    this.preflightChecks,
    this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Whether this part's warranty has expired.
  bool get isWarrantyExpired {
    if (warrantyExpiration == null) return false;
    return DateTime.now().isAfter(warrantyExpiration!);
  }

  /// Whether the warranty expires within the given number of days.
  bool isWarrantyExpiringSoon({int withinDays = 30}) {
    if (warrantyExpiration == null) return false;
    if (isWarrantyExpired) return false;
    final daysLeft = warrantyExpiration!.difference(DateTime.now()).inDays;
    return daysLeft <= withinDays;
  }

  /// Days remaining on warranty, or null if no warranty set.
  int? get warrantyDaysRemaining {
    if (warrantyExpiration == null) return null;
    final diff = warrantyExpiration!.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  /// Creates a copy with updated fields.
  MotoPart copyWith({
    String? name,
    String? category,
    String? brand,
    String? modelNumber,
    DateTime? purchaseDate,
    double? purchasePrice,
    int? warrantyMonths,
    DateTime? warrantyExpiration,
    bool? isInstalled,
    String? installationNotes,
    String? torqueNotes,
    String? preflightChecks,
    String? imagePath,
  }) {
    return MotoPart(
      id: id,
      motorcycleId: motorcycleId,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      modelNumber: modelNumber ?? this.modelNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      warrantyMonths: warrantyMonths ?? this.warrantyMonths,
      warrantyExpiration: warrantyExpiration ?? this.warrantyExpiration,
      isInstalled: isInstalled ?? this.isInstalled,
      installationNotes: installationNotes ?? this.installationNotes,
      torqueNotes: torqueNotes ?? this.torqueNotes,
      preflightChecks: preflightChecks ?? this.preflightChecks,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt,
    );
  }
}
