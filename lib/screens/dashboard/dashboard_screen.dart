import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:motoparts_manager/providers/motorcycle_provider.dart';
import 'package:motoparts_manager/providers/parts_provider.dart';
import 'package:motoparts_manager/screens/add_edit_part/add_edit_part_screen.dart';
import 'package:motoparts_manager/theme/app_colors.dart';
import 'package:motoparts_manager/theme/app_spacing.dart';
import 'package:motoparts_manager/widgets/empty_state.dart';
import 'package:motoparts_manager/widgets/motorcycle_card.dart';
import 'package:motoparts_manager/widgets/primary_button.dart';
import 'package:motoparts_manager/widgets/section_header.dart';
import 'package:motoparts_manager/widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, this.onMotorcycleTap, this.onInventoryTap});

  final VoidCallback? onMotorcycleTap;
  final VoidCallback? onInventoryTap;

  @override
  Widget build(BuildContext context) {
    final motorcycle = context.watch<MotorcycleProvider>().motorcycle;
    final partsProvider = context.watch<PartsProvider>();
    final recentParts = [...partsProvider.parts]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final warrantyCount = partsProvider.partsExpiringSoon.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ACTIVE MOTORCYCLE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (motorcycle != null)
              MotorcycleCard(motorcycle: motorcycle, onTap: onMotorcycleTap)
            else
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      const Icon(Icons.two_wheeler_outlined),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Set up your motorcycle to start tracking parts.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: onMotorcycleTap,
                        icon: const Icon(Icons.chevron_right),
                        tooltip: 'Set up motorcycle',
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Tracked Parts',
                    value: partsProvider.partsCount.toString(),
                    icon: Icons.inventory_2_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StatCard(
                    label: 'Expiring Warranties',
                    value: warrantyCount.toString(),
                    icon: Icons.shield_outlined,
                    color: warrantyCount > 0 ? AppColors.error : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Add New Part',
              icon: Icons.add,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddEditPartScreen()),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SectionHeader(
              title: 'Recent Activity',
              trailing: partsProvider.parts.isEmpty
                  ? null
                  : TextButton(
                      onPressed: onInventoryTap,
                      child: const Text('VIEW ALL'),
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (recentParts.isEmpty)
              const EmptyState(
                icon: Icons.history,
                title: 'No recent activity',
                message: 'Parts you add will appear here.',
              )
            else
              ...recentParts
                  .take(4)
                  .map(
                    (part) => _ActivityItem(
                      title: part.isInstalled ? 'Part installed' : 'Part added',
                      partName: part.name,
                      date: part.createdAt,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.title,
    required this.partName,
    required this.date,
  });

  final String title;
  final String partName;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.build_outlined, size: 16),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  partName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            DateFormat('MMM d').format(date),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
