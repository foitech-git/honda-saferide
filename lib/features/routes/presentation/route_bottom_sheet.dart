import 'package:flutter/material.dart';
import '../../../domain/entities/route_option.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/buttons/app_buttons.dart';

class RouteBottomSheet extends StatelessWidget {
  final RouteOption route;
  final VoidCallback onStartRoute;
  final VoidCallback onCancel;

  const RouteBottomSheet({
    super.key,
    required this.route,
    required this.onStartRoute,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    Color typeColor;
    IconData typeIcon;

    switch (route.type) {
      case RouteType.safe:
        typeColor = AppColors.routeSafe;
        typeIcon = Icons.shield_outlined;
        break;
      case RouteType.wellLit:
        typeColor = AppColors.routeWellLit;
        typeIcon = Icons.lightbulb_outline;
        break;
      case RouteType.mostUsed:
        typeColor = AppColors.routeMostUsed;
        typeIcon = Icons.timeline;
        break;
      default:
        typeColor = AppColors.primaryText;
        typeIcon = Icons.directions;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(typeIcon, color: typeColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${route.metrics.formattedDuration} • ${route.metrics.formattedDistance}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onCancel,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildSignalChip(Icons.edit_road, route.signals.roadConditions),
              const SizedBox(width: 8),
              _buildSignalChip(Icons.warning_amber, '${route.signals.incidents} Incidents'),
              const SizedBox(width: 8),
              _buildSignalChip(Icons.lightbulb, route.signals.lighting),
            ],
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Start Route',
            onPressed: onStartRoute,
          ),
        ],
      ),
    );
  }

  Widget _buildSignalChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppColors.secondaryText),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
