import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:motoparts_manager/models/part.dart';
import 'package:motoparts_manager/providers/parts_provider.dart';
import 'package:motoparts_manager/screens/add_edit_part/add_edit_part_screen.dart';
import 'package:motoparts_manager/theme/app_colors.dart';
import 'package:motoparts_manager/theme/app_spacing.dart';
import 'package:motoparts_manager/widgets/empty_state.dart';
import 'package:motoparts_manager/widgets/part_list_tile.dart';
import 'package:motoparts_manager/widgets/primary_button.dart';
import 'package:motoparts_manager/widgets/search_filter_bar.dart';

class PartsInventoryScreen extends StatefulWidget {
  const PartsInventoryScreen({super.key});

  @override
  State<PartsInventoryScreen> createState() => _PartsInventoryScreenState();
}

class _PartsInventoryScreenState extends State<PartsInventoryScreen> {
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final parts = context.watch<PartsProvider>().parts.where((part) {
      final query = _searchQuery.trim().toLowerCase();
      final haystack = [
        part.name,
        part.modelNumber ?? '',
        part.brand ?? '',
        part.category,
      ].join(' ').toLowerCase();
      return (query.isEmpty || haystack.contains(query)) &&
          (_selectedCategory == null || part.category == _selectedCategory);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Parts Inventory')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: SearchFilterBar(
              categories: PartCategory.all,
              selectedCategory: _selectedCategory,
              onSearchChanged: (value) => setState(() => _searchQuery = value),
              onCategorySelected: (value) =>
                  setState(() => _selectedCategory = value),
            ),
          ),
          Expanded(
            child: parts.isEmpty
                ? EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: _searchQuery.isEmpty && _selectedCategory == null
                        ? 'No parts tracked yet'
                        : 'No matching parts',
                    message: _searchQuery.isEmpty && _selectedCategory == null
                        ? 'Add your first part to start building your inventory.'
                        : 'Try another search or category.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.sm,
                    ),
                    itemCount: parts.length,
                    itemBuilder: (context, index) => PartListTile(
                      part: parts[index],
                      onTap: () => _showPartDetails(context, parts[index]),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: PrimaryButton(
              label: 'Add New Part',
              icon: Icons.add,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddEditPartScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPartDetails(BuildContext context, MotoPart part) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
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
              Text(part.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${part.category}  •  ${part.isInstalled ? 'Installed' : 'In box'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (part.brand?.isNotEmpty ?? false)
                _DetailRow(label: 'Brand', value: part.brand!),
              if (part.modelNumber?.isNotEmpty ?? false)
                _DetailRow(label: 'SKU', value: part.modelNumber!),
              if (part.purchasePrice != null)
                _DetailRow(
                  label: 'Price',
                  value: NumberFormat.currency(
                    locale: 'en_PH',
                    symbol: '₱',
                    decimalDigits: 0,
                  ).format(part.purchasePrice),
                ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('DELETE'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      onPressed: () {
                        context.read<PartsProvider>().deletePart(part.id);
                        Navigator.pop(sheetContext);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('EDIT'),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddEditPartScreen(part: part),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
