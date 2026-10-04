import 'package:flutter/foundation.dart';
import 'package:motoparts_manager/models/part.dart';
import 'package:motoparts_manager/services/hive_service.dart';

/// Provider managing the motorcycle parts inventory state.
class PartsProvider extends ChangeNotifier {
  List<MotoPart> _parts = [];

  PartsProvider() {
    _init();
  }

  void _init() {
    try {
      _parts = HiveService.getParts();
    } catch (_) {
      // Hive box may not be open yet during initial construction or testing.
    }
  }

  /// All tracked parts.
  List<MotoPart> get parts => List.unmodifiable(_parts);

  /// Total number of tracked parts.
  int get partsCount => _parts.length;

  /// Parts currently marked as installed.
  List<MotoPart> get installedParts =>
      _parts.where((part) => part.isInstalled).toList();

  /// Parts currently not installed (spares / in-box).
  List<MotoPart> get uninstalledParts =>
      _parts.where((part) => !part.isInstalled).toList();

  /// Parts whose warranty expires within 30 days.
  List<MotoPart> get partsExpiringSoon =>
      _parts.where((part) => part.isWarrantyExpiringSoon()).toList();

  /// Returns parts filtered by category (case-insensitive).
  List<MotoPart> getPartsByCategory(String category) {
    final lowerCat = category.toLowerCase();
    return _parts
        .where((part) => part.category.toLowerCase() == lowerCat)
        .toList();
  }

  /// Finds a part by its unique [id], or null if not found.
  MotoPart? getPartById(String id) {
    try {
      return _parts.firstWhere((part) => part.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Loads all parts from Hive and notifies listeners.
  Future<void> loadParts() async {
    try {
      _parts = HiveService.getParts();
    } catch (_) {
      _parts = [];
    }
    notifyListeners();
  }

  /// Adds a new part, persists it to Hive, and notifies listeners.
  Future<void> addPart(MotoPart part) async {
    await HiveService.addPart(part);
    _parts = HiveService.getParts();
    notifyListeners();
  }

  /// Updates an existing part, persists to Hive, and notifies listeners.
  Future<void> updatePart(MotoPart part) async {
    await HiveService.updatePart(part);
    _parts = HiveService.getParts();
    notifyListeners();
  }

  /// Deletes a part by its [id], persists deletion to Hive, and notifies listeners.
  Future<void> deletePart(String id) async {
    await HiveService.deletePart(id);
    _parts.removeWhere((part) => part.id == id);
    notifyListeners();
  }
}
