import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:motoparts_manager/models/part.dart';
import 'package:motoparts_manager/providers/motorcycle_provider.dart';
import 'package:motoparts_manager/providers/parts_provider.dart';
import 'package:motoparts_manager/theme/app_colors.dart';
import 'package:motoparts_manager/theme/app_spacing.dart';
import 'package:motoparts_manager/widgets/app_text_field.dart';
import 'package:motoparts_manager/widgets/primary_button.dart';

class AddEditPartScreen extends StatefulWidget {
  const AddEditPartScreen({super.key, this.part});

  final MotoPart? part;

  @override
  State<AddEditPartScreen> createState() => _AddEditPartScreenState();
}

class _AddEditPartScreenState extends State<AddEditPartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('MMM d, yyyy');

  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _modelNumberController;
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _warrantyMonthsController;
  late final TextEditingController _installationNotesController;
  late final TextEditingController _torqueNotesController;
  late final TextEditingController _purchaseDateController;
  late final TextEditingController _warrantyExpirationController;

  String _selectedCategory = PartCategory.engine;
  DateTime? _purchaseDate;
  DateTime? _warrantyExpiration;
  bool _fitmentVerified = false;
  bool _fastenersChecked = false;

  @override
  void initState() {
    super.initState();
    final part = widget.part;
    _nameController = TextEditingController(text: part?.name ?? '');
    _brandController = TextEditingController(text: part?.brand ?? '');
    _modelNumberController = TextEditingController(
      text: part?.modelNumber ?? '',
    );
    _purchasePriceController = TextEditingController(
      text: part?.purchasePrice?.toString() ?? '',
    );
    _warrantyMonthsController = TextEditingController(
      text: part?.warrantyMonths?.toString() ?? '',
    );
    _installationNotesController = TextEditingController(
      text: part?.installationNotes ?? '',
    );
    _torqueNotesController = TextEditingController(
      text: part?.torqueNotes ?? '',
    );
    _purchaseDate = part?.purchaseDate;
    _warrantyExpiration = part?.warrantyExpiration;
    _purchaseDateController = TextEditingController(
      text: _purchaseDate == null ? '' : _dateFormat.format(_purchaseDate!),
    );
    _warrantyExpirationController = TextEditingController(
      text: _warrantyExpiration == null
          ? ''
          : _dateFormat.format(_warrantyExpiration!),
    );
    _selectedCategory = part?.category ?? PartCategory.engine;
    final checks = part?.preflightChecks?.toLowerCase() ?? '';
    _fitmentVerified = checks.contains('fitment');
    _fastenersChecked = checks.contains('fasteners');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelNumberController.dispose();
    _purchasePriceController.dispose();
    _warrantyMonthsController.dispose();
    _installationNotesController.dispose();
    _torqueNotesController.dispose();
    _purchaseDateController.dispose();
    _warrantyExpirationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool warranty}) async {
    final current = warranty ? _warrantyExpiration : _purchaseDate;
    final date = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    setState(() {
      if (warranty) {
        _warrantyExpiration = date;
        _warrantyExpirationController.text = _dateFormat.format(date);
      } else {
        _purchaseDate = date;
        _purchaseDateController.text = _dateFormat.format(date);
      }
    });
  }

  void _showScanEntry() {
    final controller = TextEditingController(text: _modelNumberController.text);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Scan Code'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Scanned SKU or barcode',
            prefixIcon: Icon(Icons.qr_code_scanner),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(
                () => _modelNumberController.text = controller.text.trim(),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('USE CODE'),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }

  void _savePart() {
    if (!_formKey.currentState!.validate()) return;
    final motorcycleId =
        context.read<MotorcycleProvider>().motorcycle?.id ?? '';
    final warrantyMonths = int.tryParse(_warrantyMonthsController.text);
    var expiration = _warrantyExpiration;
    if (expiration == null && _purchaseDate != null && warrantyMonths != null) {
      expiration = DateTime(
        _purchaseDate!.year,
        _purchaseDate!.month + warrantyMonths,
        _purchaseDate!.day,
      );
    }

    final checks = <String>[
      if (_fitmentVerified) 'Fitment verified',
      if (_fastenersChecked) 'Fasteners checked',
    ];
    final part = MotoPart(
      id: widget.part?.id ?? const Uuid().v4(),
      motorcycleId: motorcycleId,
      name: _nameController.text.trim(),
      category: _selectedCategory,
      brand: _nullIfEmpty(_brandController.text),
      modelNumber: _nullIfEmpty(_modelNumberController.text),
      purchaseDate: _purchaseDate,
      purchasePrice: double.tryParse(_purchasePriceController.text),
      warrantyMonths: warrantyMonths,
      warrantyExpiration: expiration,
      isInstalled: widget.part?.isInstalled ?? true,
      installationNotes: _nullIfEmpty(_installationNotesController.text),
      torqueNotes: _nullIfEmpty(_torqueNotesController.text),
      preflightChecks: checks.isEmpty ? null : checks.join(', '),
      imagePath: widget.part?.imagePath,
      createdAt: widget.part?.createdAt,
    );

    if (widget.part == null) {
      context.read<PartsProvider>().addPart(part);
    } else {
      context.read<PartsProvider>().updatePart(part);
    }
    Navigator.of(context).pop();
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final checksPassed = [
      _fitmentVerified,
      _fastenersChecked,
    ].where((v) => v).length;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.part == null ? 'Add Part' : 'Edit Part'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _FormSectionTitle(
                title: 'Identification',
                subtitle: 'Core part details and reference information.',
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _nameController,
                label: 'Part Name *',
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a part name'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category *'),
                items: PartCategory.all
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(
                  () => _selectedCategory = value ?? _selectedCategory,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _brandController,
                label: 'Brand / Manufacturer',
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _modelNumberController,
                label: 'Model / SKU',
                suffixIcon: IconButton(
                  onPressed: _showScanEntry,
                  tooltip: 'Scan code',
                  icon: const Icon(Icons.qr_code_scanner),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _showScanEntry,
                  icon: const Icon(Icons.qr_code_scanner, size: 20),
                  label: const Text('SCAN CODE'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _FormSectionTitle(
                title: 'Purchase & Warranty',
                subtitle: 'Optional details for receipts and reminders.',
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _purchaseDateController,
                label: 'Purchase Date',
                readOnly: true,
                onTap: () => _pickDate(warranty: false),
                suffixIcon: const Icon(Icons.calendar_today_outlined),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _purchasePriceController,
                label: 'Price (₱)',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _warrantyMonthsController,
                label: 'Warranty Term (Months)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _warrantyExpirationController,
                label: 'Expiration',
                hint: 'Auto-calculated when left empty',
                readOnly: true,
                onTap: () => _pickDate(warranty: true),
                suffixIcon: const Icon(Icons.calendar_today_outlined),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _FormSectionTitle(
                title: 'Installation',
                subtitle: 'Record fitment details for future service.',
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _installationNotesController,
                label: 'Installation Notes',
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _torqueNotesController,
                label: 'Torque Notes',
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pre-Flight Checks',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '$checksPassed/2 Passed',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                value: _fitmentVerified,
                onChanged: (value) =>
                    setState(() => _fitmentVerified = value ?? false),
                title: const Text('Fitment verified'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _fastenersChecked,
                onChanged: (value) =>
                    setState(() => _fastenersChecked = value ?? false),
                title: const Text('Fasteners checked'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: widget.part == null ? 'Save Part' : 'Save Changes',
                icon: Icons.check,
                onPressed: _savePart,
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormSectionTitle extends StatelessWidget {
  const _FormSectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}
