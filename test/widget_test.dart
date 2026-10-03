import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:motoparts_manager/app.dart';
import 'package:motoparts_manager/providers/maintenance_provider.dart';
import 'package:motoparts_manager/providers/motorcycle_provider.dart';
import 'package:motoparts_manager/providers/parts_provider.dart';

void main() {
  testWidgets('mobile shell exposes all primary destinations', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MotorcycleProvider()),
          ChangeNotifierProvider(create: (_) => PartsProvider()),
          ChangeNotifierProvider(create: (_) => MaintenanceProvider()),
        ],
        child: const MotoPartsApp(),
      ),
    );

    expect(find.text('Dashboard'), findsNWidgets(2));
    expect(find.text('My Bike'), findsOneWidget);
    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Add Part'), findsOneWidget);

    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();
    expect(find.text('Parts Inventory'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText ==
                'Search part name, SKU, or category...',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Add Part'));
    await tester.pumpAndSettle();
    expect(find.text('Identification'), findsOneWidget);
    expect(find.text('Purchase & Warranty'), findsOneWidget);
    expect(find.text('Installation'), findsOneWidget);
  });
}
