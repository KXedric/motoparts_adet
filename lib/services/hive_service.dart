import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:motoparts_manager/hive_registrar.g.dart';
import 'package:motoparts_manager/models/maintenance_record.dart';
import 'package:motoparts_manager/models/motorcycle.dart';
import 'package:motoparts_manager/models/part.dart';

/// Service managing all Hive box operations for MotoParts Manager.
class HiveService {
  HiveService._();

  static const String motorcycleBoxName = 'motorcycle';
  static const String partsBoxName = 'parts';
  static const String maintenanceBoxName = 'maintenance';

  static late Box<Motorcycle> _motorcycleBox;
  static late Box<MotoPart> _partsBox;
  static late Box<MaintenanceRecord> _maintenanceBox;

  /// Exposes the motorcycle Hive box.
  static Box<Motorcycle> get motorcycleBox => _motorcycleBox;

  /// Exposes the parts Hive box.
  static Box<MotoPart> get partsBox => _partsBox;

  /// Exposes the maintenance Hive box.
  static Box<MaintenanceRecord> get maintenanceBox => _maintenanceBox;

  /// Initializes Hive for Flutter, registers all model type adapters,
  /// and opens the required boxes.
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();

    _motorcycleBox = await Hive.openBox<Motorcycle>(motorcycleBoxName);
    _partsBox = await Hive.openBox<MotoPart>(partsBoxName);
    _maintenanceBox = await Hive.openBox<MaintenanceRecord>(maintenanceBoxName);
  }

  // ==========================================
  // Motorcycle CRUD (Single motorcycle MVP)
  // ==========================================

  /// Returns the current motorcycle, or null if none is saved.
  /// If [id] is provided, attempts to retrieve the motorcycle with that ID.
  static Motorcycle? getMotorcycle([String? id]) {
    if (id != null) {
      return _motorcycleBox.get(id);
    }
    return _motorcycleBox.values.firstOrNull;
  }

  /// Saves or updates the motorcycle in the box.
  static Future<void> saveMotorcycle(Motorcycle motorcycle) async {
    await _motorcycleBox.put(motorcycle.id, motorcycle);
  }

  /// Deletes the motorcycle by [id], or clears the motorcycle box if [id] is omitted.
  static Future<void> deleteMotorcycle([String? id]) async {
    if (id != null) {
      await _motorcycleBox.delete(id);
    } else {
      await _motorcycleBox.clear();
    }
  }

  // ==========================================
  // Parts CRUD
  // ==========================================

  /// Returns all parts in the box.
  static List<MotoPart> getParts() {
    return _partsBox.values.toList();
  }

  /// Returns a specific part by its [id], or null if not found.
  static MotoPart? getPartById(String id) {
    return _partsBox.get(id);
  }

  /// Adds a new part to the box.
  static Future<void> addPart(MotoPart part) async {
    await _partsBox.put(part.id, part);
  }

  /// Updates an existing part in the box.
  static Future<void> updatePart(MotoPart part) async {
    await _partsBox.put(part.id, part);
  }

  /// Deletes a part by its [id].
  static Future<void> deletePart(String id) async {
    await _partsBox.delete(id);
  }

  /// Returns all parts belonging to the specified [category] (case-insensitive).
  static List<MotoPart> getPartsByCategory(String category) {
    final lowerCat = category.toLowerCase();
    return _partsBox.values
        .where((part) => part.category.toLowerCase() == lowerCat)
        .toList();
  }

  // ==========================================
  // Maintenance CRUD
  // ==========================================

  /// Returns all maintenance records, sorted by service date descending (newest first).
  static List<MaintenanceRecord> getMaintenanceRecords() {
    final records = _maintenanceBox.values.toList();
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  /// Adds a new maintenance record to the box.
  static Future<void> addMaintenanceRecord(MaintenanceRecord record) async {
    await _maintenanceBox.put(record.id, record);
  }

  /// Deletes a maintenance record by its [id].
  static Future<void> deleteMaintenanceRecord(String id) async {
    await _maintenanceBox.delete(id);
  }

  // ==========================================
  // Query Helpers
  // ==========================================

  /// Returns parts whose warranty expires within [withinDays] days (default: 30),
  /// sorted by expiration date ascending.
  static List<MotoPart> getPartsExpiringSoon([int withinDays = 30]) {
    final parts = _partsBox.values
        .where((part) => part.isWarrantyExpiringSoon(withinDays: withinDays))
        .toList();
    parts.sort((a, b) {
      if (a.warrantyExpiration == null && b.warrantyExpiration == null) {
        return 0;
      }
      if (a.warrantyExpiration == null) return 1;
      if (b.warrantyExpiration == null) return -1;
      return a.warrantyExpiration!.compareTo(b.warrantyExpiration!);
    });
    return parts;
  }

  /// Returns the most recent activities (parts added and maintenance performed)
  /// sorted by `createdAt` descending, up to [limit] items.
  static List<dynamic> getRecentActivity([int limit = 10]) {
    final List<dynamic> activities = [
      ..._partsBox.values,
      ..._maintenanceBox.values,
    ];

    activities.sort((a, b) {
      final DateTime aDate = _getActivityCreatedAt(a);
      final DateTime bDate = _getActivityCreatedAt(b);
      return bDate.compareTo(aDate);
    });

    if (activities.length <= limit) {
      return activities;
    }
    return activities.sublist(0, limit);
  }

  static DateTime _getActivityCreatedAt(dynamic item) {
    if (item is MotoPart) return item.createdAt;
    if (item is MaintenanceRecord) return item.createdAt;
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Closes all Hive boxes.
  static Future<void> close() async {
    await Hive.close();
  }
}
