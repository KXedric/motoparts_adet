import 'package:flutter/material.dart';
import 'package:motoparts_manager/theme/app_colors.dart';
import 'package:motoparts_manager/theme/app_spacing.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color ?? AppColors.secondary),
              const Spacer(),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                maxLines: 2,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
