import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motoparts_manager/models/part.dart';
import 'package:motoparts_manager/theme/app_colors.dart';
import 'package:motoparts_manager/theme/app_spacing.dart';

class PartListTile extends StatelessWidget {
  const PartListTile({super.key, required this.part, this.onTap});

  final MotoPart part;
  final VoidCallback? onTap;

  IconData _categoryIcon(String category) {
    switch (category) {
      case PartCategory.engine:
        return Icons.settings_outlined;
      case PartCategory.exhaust:
        return Icons.air;
      case PartCategory.brakes:
        return Icons.speed;
      case PartCategory.tires:
        return Icons.tire_repair_outlined;
      case PartCategory.suspension:
        return Icons.compress;
      case PartCategory.electrical:
        return Icons.electrical_services_outlined;
      default:
        return Icons.build_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasWarranty = part.warrantyExpiration != null;
    final needsAttention =
        part.isWarrantyExpired || part.isWarrantyExpiringSoon();

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _categoryIcon(part.category),
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${part.category.toUpperCase()}  •  ${part.isInstalled ? 'INSTALLED' : 'IN BOX'}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      part.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    if (part.modelNumber?.trim().isNotEmpty ?? false) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'SKU: ${part.modelNumber}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (hasWarranty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Icon(
                            part.isWarrantyExpired
                                ? Icons.error_outline
                                : Icons.shield_outlined,
                            size: 16,
                            color: needsAttention
                                ? AppColors.error
                                : AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              part.isWarrantyExpired
                                  ? 'Warranty expired'
                                  : 'Warranty: ${DateFormat('MMM yyyy').format(part.warrantyExpiration!)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: needsAttention
                                    ? AppColors.error
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (part.purchasePrice != null)
                    Text(
                      NumberFormat.currency(
                        locale: 'en_PH',
                        symbol: '₱',
                        decimalDigits: 0,
                      ).format(part.purchasePrice),
                      style: theme.textTheme.titleMedium,
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.onSurfaceVariant,
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
