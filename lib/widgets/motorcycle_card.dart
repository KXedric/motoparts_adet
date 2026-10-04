import 'package:flutter/material.dart';
import 'package:motoparts_manager/models/motorcycle.dart';
import 'package:motoparts_manager/theme/app_colors.dart';
import 'package:motoparts_manager/theme/app_spacing.dart';

class MotorcycleCard extends StatelessWidget {
  const MotorcycleCard({super.key, required this.motorcycle, this.onTap});

  final Motorcycle motorcycle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final displacement = motorcycle.engineDisplacement.trim().isEmpty
        ? 'Engine not specified'
        : motorcycle.engineDisplacement;
    final plate = motorcycle.licensePlate?.trim();

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.two_wheeler,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      motorcycle.model,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${motorcycle.year}  •  $displacement',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (plate != null && plate.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Plate: $plate',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
