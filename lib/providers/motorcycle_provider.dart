import 'package:flutter/foundation.dart';
import 'package:motoparts_manager/models/motorcycle.dart';
import 'package:motoparts_manager/services/hive_service.dart';

/// Provider managing the motorcycle profile state.
class MotorcycleProvider extends ChangeNotifier {
  Motorcycle? _motorcycle;

  MotorcycleProvider() {
    _init();
  }

  void _init() {
    try {
      _motorcycle = HiveService.getMotorcycle();
    } catch (_) {
      // Hive box may not be open yet during initial construction or testing.
    }
  }

  /// The currently tracked motorcycle, or null if none is set.
  Motorcycle? get motorcycle => _motorcycle;

  /// Whether a motorcycle is currently registered.
  bool get hasMotorcycle => _motorcycle != null;

  /// Loads the motorcycle from Hive and notifies listeners.
  Future<void> loadMotorcycle() async {
    try {
      _motorcycle = HiveService.getMotorcycle();
    } catch (_) {
      _motorcycle = null;
    }
    notifyListeners();
  }

  /// Saves or updates the motorcycle profile.
  Future<void> saveMotorcycle(Motorcycle motorcycle) async {
    await HiveService.saveMotorcycle(motorcycle);
    _motorcycle = motorcycle;
    notifyListeners();
  }

  /// Updates individual fields of the current motorcycle profile.
  Future<void> updateMotorcycle({
    String? model,
    int? year,
    String? engineDisplacement,
    String? licensePlate,
    double? mileage,
    String? imageUrl,
    Map<String, String>? specs,
  }) async {
    if (_motorcycle == null) return;

    final updated = _motorcycle!.copyWith(
      model: model,
      year: year,
      engineDisplacement: engineDisplacement,
      licensePlate: licensePlate,
      mileage: mileage,
      imageUrl: imageUrl,
      specs: specs,
    );

    await saveMotorcycle(updated);
  }

  /// Deletes the current motorcycle profile.
  Future<void> deleteMotorcycle() async {
    if (_motorcycle != null) {
      await HiveService.deleteMotorcycle(_motorcycle!.id);
      _motorcycle = null;
      notifyListeners();
    }
  }
}
