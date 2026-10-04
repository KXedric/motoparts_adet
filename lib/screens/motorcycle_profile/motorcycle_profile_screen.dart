import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:motoparts_manager/models/maintenance_record.dart';
import 'package:motoparts_manager/models/motorcycle.dart';
import 'package:motoparts_manager/providers/maintenance_provider.dart';
import 'package:motoparts_manager/providers/motorcycle_provider.dart';
import 'package:motoparts_manager/theme/app_colors.dart';
import 'package:motoparts_manager/theme/app_spacing.dart';
import 'package:motoparts_manager/widgets/empty_state.dart';
import 'package:motoparts_manager/widgets/primary_button.dart';
import 'package:motoparts_manager/widgets/section_header.dart';

class MotorcycleProfileScreen extends StatelessWidget {
  const MotorcycleProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final motorcycle = context.watch<MotorcycleProvider>().motorcycle;
    final records = context.watch<MaintenanceProvider>().records;

    if (motorcycle == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Bike')),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: EmptyState(
              icon: Icons.two_wheeler_outlined,
              title: 'No motorcycle configured',
              message:
                  'Add your motorcycle details to track parts and maintenance.',
              action: ElevatedButton(
                onPressed: () => _showEditMotorcycleDialog(context, null),
                child: const Text('SET UP MOTORCYCLE'),
              ),
            ),
          ),
        ),
      );
    }

    final upcoming = records
        .where((record) => !record.date.isBefore(_today()))
        .take(3)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bike')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BikeHero(motorcycle: motorcycle),
            const SizedBox(height: AppSpacing.md),
            const _DiagnosticStatus(),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Technical Specifications'),
            const SizedBox(height: AppSpacing.md),
            _SpecificationsGrid(motorcycle: motorcycle),
            const SizedBox(height: AppSpacing.lg),
            SectionHeader(
              title: 'Upcoming Maintenance',
              trailing: TextButton(
                onPressed: () => _showSchedule(context, records),
                child: const Text('VIEW SCHEDULE'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (upcoming.isEmpty)
              const _NoMaintenanceCard()
            else
              ...upcoming.map((record) => _MaintenanceCard(record: record)),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Log Service / Maintenance',
              icon: Icons.add,
              onPressed: () => _showLogMaintenanceDialog(context),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () => _showEditMotorcycleDialog(context, motorcycle),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('EDIT MOTORCYCLE INFO'),
            ),
          ],
        ),
      ),
    );
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static void _showSchedule(
    BuildContext context,
    List<MaintenanceRecord> records,
  ) {
    final sorted = [...records]..sort((a, b) => b.date.compareTo(a.date));
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Maintenance Schedule',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              if (sorted.isEmpty)
                const EmptyState(
                  icon: Icons.event_note_outlined,
                  title: 'No maintenance logged',
                  message: 'New service entries will appear here.',
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: sorted.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, index) {
                      final record = sorted[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(record.title),
                        subtitle: Text(
                          '${DateFormat('MMM d, yyyy').format(record.date)}${record.mileageAtService == null ? '' : '  •  ${record.mileageAtService!.toStringAsFixed(0)} km'}',
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showEditMotorcycleDialog(
    BuildContext context,
    Motorcycle? motorcycle,
  ) {
    final modelController = TextEditingController(text: motorcycle?.model);
    final yearController = TextEditingController(
      text: motorcycle?.year.toString(),
    );
    final displacementController = TextEditingController(
      text: motorcycle?.engineDisplacement,
    );
    final plateController = TextEditingController(
      text: motorcycle?.licensePlate,
    );
    final mileageController = TextEditingController(
      text: motorcycle?.mileage.toStringAsFixed(0),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          motorcycle == null ? 'Set Up Motorcycle' : 'Edit Motorcycle',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Model'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: displacementController,
                decoration: const InputDecoration(
                  labelText: 'Engine Displacement',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: plateController,
                decoration: const InputDecoration(labelText: 'License Plate'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: mileageController,
                decoration: const InputDecoration(labelText: 'Odometer (km)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              final updated =
                  motorcycle?.copyWith(
                    model: modelController.text.trim(),
                    year: int.tryParse(yearController.text) ?? motorcycle.year,
                    engineDisplacement: displacementController.text.trim(),
                    licensePlate: plateController.text.trim(),
                    mileage:
                        double.tryParse(mileageController.text) ??
                        motorcycle.mileage,
                  ) ??
                  Motorcycle(
                    id: const Uuid().v4(),
                    model: modelController.text.trim(),
                    year:
                        int.tryParse(yearController.text) ??
                        DateTime.now().year,
                    engineDisplacement: displacementController.text.trim(),
                    licensePlate: plateController.text.trim(),
                    mileage: double.tryParse(mileageController.text) ?? 0,
                  );
              context.read<MotorcycleProvider>().saveMotorcycle(updated);
              Navigator.pop(dialogContext);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  static void _showLogMaintenanceDialog(BuildContext context) {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    final mileageController = TextEditingController();
    var selectedDate = DateTime.now();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Log Maintenance'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task / Service',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) setDialogState(() => selectedDate = date);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(DateFormat('MMM d, yyyy').format(selectedDate)),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: mileageController,
                  decoration: const InputDecoration(labelText: 'Mileage (km)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                final motorcycle = context
                    .read<MotorcycleProvider>()
                    .motorcycle;
                if (motorcycle == null || titleController.text.trim().isEmpty) {
                  return;
                }
                context.read<MaintenanceProvider>().addRecord(
                  MaintenanceRecord(
                    id: const Uuid().v4(),
                    motorcycleId: motorcycle.id,
                    title: titleController.text.trim(),
                    date: selectedDate,
                    mileageAtService: double.tryParse(mileageController.text),
                    notes: notesController.text.trim().isEmpty
                        ? null
                        : notesController.text.trim(),
                  ),
                );
                Navigator.pop(dialogContext);
              },
              child: const Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BikeHero extends StatelessWidget {
  const _BikeHero({required this.motorcycle});

  final Motorcycle motorcycle;

  @override
  Widget build(BuildContext context) {
    final vin = motorcycle.specs['VIN'];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.two_wheeler, size: 32),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        motorcycle.model,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${motorcycle.year}  •  ${motorcycle.engineDisplacement}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _HeroDetail(
                    label: 'ODOMETER',
                    value: '${motorcycle.mileage.toStringAsFixed(0)} km',
                  ),
                ),
                Expanded(
                  child: _HeroDetail(
                    label: 'PLATE',
                    value: motorcycle.licensePlate?.isNotEmpty == true
                        ? motorcycle.licensePlate!
                        : 'Not set',
                  ),
                ),
              ],
            ),
            if (vin?.isNotEmpty == true) ...[
              const SizedBox(height: AppSpacing.md),
              _HeroDetail(label: 'VIN REFERENCE', value: vin!),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroDetail extends StatelessWidget {
  const _HeroDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _DiagnosticStatus extends StatelessWidget {
  const _DiagnosticStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.secondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diagnostic status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'No issues reported',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecificationsGrid extends StatelessWidget {
  const _SpecificationsGrid({required this.motorcycle});

  final Motorcycle motorcycle;

  @override
  Widget build(BuildContext context) {
    final specs = [
      (
        'Engine',
        motorcycle.engineDisplacement.isEmpty
            ? '—'
            : motorcycle.engineDisplacement,
        motorcycle.specs['Engine type'] ?? 'Displacement',
      ),
      (
        'Output',
        motorcycle.specs['Output'] ?? '—',
        motorcycle.specs['Torque'] ?? 'Power',
      ),
      ('Weight', motorcycle.specs['Weight'] ?? '—', 'Curb weight'),
      ('Capacity', motorcycle.specs['Capacity'] ?? '—', 'Fuel tank'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.38,
      ),
      itemCount: specs.length,
      itemBuilder: (context, index) {
        final spec = specs[index];
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spec.$1.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(spec.$2, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  spec.$3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({required this.record});

  final MaintenanceRecord record;

  @override
  Widget build(BuildContext context) {
    final days = record.date
        .difference(MotorcycleProfileScreen._today())
        .inDays;
    final urgent = days <= 7;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Due ${DateFormat('MMM d, yyyy').format(record.date)}${record.mileageAtService == null ? '' : '  •  ${record.mileageAtService!.toStringAsFixed(0)} km'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: urgent ? AppColors.error : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                urgent ? 'URGENT' : 'SCHEDULED',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: urgent ? AppColors.onPrimary : AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoMaintenanceCard extends StatelessWidget {
  const _NoMaintenanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event_available_outlined,
            color: AppColors.secondary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'No upcoming maintenance scheduled.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
