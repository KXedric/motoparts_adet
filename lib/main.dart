import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motoparts_manager/app.dart';
import 'package:motoparts_manager/services/hive_service.dart';
import 'package:motoparts_manager/providers/motorcycle_provider.dart';
import 'package:motoparts_manager/providers/parts_provider.dart';
import 'package:motoparts_manager/providers/maintenance_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MotorcycleProvider()..loadMotorcycle(),
        ),
        ChangeNotifierProvider(create: (_) => PartsProvider()..loadParts()),
        ChangeNotifierProvider(
          create: (_) => MaintenanceProvider()..loadRecords(),
        ),
      ],
      child: const MotoPartsApp(),
    ),
  );
}
