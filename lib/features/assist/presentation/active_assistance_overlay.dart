import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../domain/entities/assist/assist_entities.dart';
import '../providers/assist_provider.dart';

class ActiveAssistanceOverlay extends ConsumerWidget {
  const ActiveAssistanceOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assistState = ref.watch(assistNotifierProvider);
    final request = assistState.activeRequest;

    if (request == null) return const SizedBox.shrink();

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (request.status) {
      case AssistanceStatus.idle:
      case AssistanceStatus.requested:
        statusColor = AppColors.warning;
        statusText = 'Request Pending...';
        statusIcon = Icons.hourglass_empty;
        break;
      case AssistanceStatus.accepted:
        statusColor = AppColors.routeMostUsed;
        statusText = 'Provider Accepted';
        statusIcon = Icons.check_circle;
        break;
      case AssistanceStatus.providerEnRoute:
        statusColor = AppColors.success;
        statusText = 'Provider En Route';
        statusIcon = Icons.directions_car;
        break;
      case AssistanceStatus.arrived:
        statusColor = AppColors.success;
        statusText = 'Provider Arrived';
        statusIcon = Icons.location_on;
        break;
      default:
        statusColor = AppColors.secondaryText;
        statusText = 'Status Unknown';
        statusIcon = Icons.help_outline;
    }

    return Positioned(
      bottom: 100, // Above bottom nav
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                if (assistState.isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SecondaryButton(
              label: 'Cancel Request',
              onPressed: () {
                ref.read(assistNotifierProvider.notifier).cancelAssistance();
              },
            ),
          ],
        ),
      ),
    );
  }
}
