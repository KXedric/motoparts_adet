import 'package:flutter/foundation.dart';
import 'package:motoparts_manager/models/maintenance_record.dart';
import 'package:motoparts_manager/services/hive_service.dart';

/// Provider managing motorcycle maintenance logs and Hive persistence.
class MaintenanceProvider extends ChangeNotifier {
  List<MaintenanceRecord> _records = [];

  MaintenanceProvider() {
    _init();
  }

  void _init() {
    try {
      _records = HiveService.getMaintenanceRecords();
    } catch (_) {
      // Hive box may not be open yet during initial construction or testing.
    }
  }

  /// All maintenance records sorted by service date descending.
  List<MaintenanceRecord> get records => List.unmodifiable(_records);

  /// Total count of maintenance records.
  int get recordsCount => _records.length;

  /// Returns the most recent maintenance records up to [limit] (default: 5).
  List<MaintenanceRecord> recentRecords([int limit = 5]) {
    return _records.take(limit).toList();
  }

  /// Loads all maintenance records from Hive and notifies listeners.
  Future<void> loadRecords() async {
    try {
      _records = HiveService.getMaintenanceRecords();
    } catch (_) {
      _records = [];
    }
    notifyListeners();
  }

  /// Adds a maintenance record, persists to Hive, and notifies listeners.
  Future<void> addRecord(MaintenanceRecord record) async {
    await HiveService.addMaintenanceRecord(record);
    _records = HiveService.getMaintenanceRecords();
    notifyListeners();
  }

  /// Deletes a maintenance record by [id], persists deletion to Hive, and notifies listeners.
  Future<void> deleteRecord(String id) async {
    await HiveService.deleteMaintenanceRecord(id);
    _records.removeWhere((record) => record.id == id);
    notifyListeners();
  }
}
