import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../domain/entities/sos/sos_event.dart';
import '../providers/sos_provider.dart';
import '../widgets/hold_to_activate_button.dart';

class SosScreen extends ConsumerWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sosState = ref.watch(sosNotifierProvider);

    return SafeRideScaffold(
      title: 'Emergency',
      body: Container(
        color: sosState.status == SOSStatus.active ? AppColors.primaryRed.withOpacity(0.05) : AppColors.background,
        child: SafeArea(
        child: sosState.status == SOSStatus.active
            ? _buildActiveState(context, ref, sosState.activeEvent!)
            : _buildInactiveState(context, ref),
        ),
      ),
    );
  }

  Widget _buildInactiveState(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text(
            'Emergency SOS',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Press and hold to send SOS',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          HoldToActivateButton(
            onActivated: () {
              ref.read(sosNotifierProvider.notifier).activateSOS('user_1');
            },
          ),
          const Spacer(),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText, fontSize: 16)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildActiveState(BuildContext context, WidgetRef ref, SOSEvent event) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.danger),
            ),
            child: Column(
              children: [
                const Icon(Icons.warning_rounded, color: AppColors.danger, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'SOS ACTIVE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.danger,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Activated at ${event.activatedAt.toLocal().toString().split('.')[0]}',
                  style: const TextStyle(color: AppColors.primaryText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildStatusRow(Icons.location_on, 'Location Sharing', event.isLocationShared ? 'Active' : 'Failed', AppColors.success),
          const SizedBox(height: 12),
          _buildStatusRow(Icons.directions_car, 'Vehicle Status', event.vehicleStatus, AppColors.routeMostUsed),
          const Spacer(),
          AppButton(
            label: 'Call Emergency Services',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            label: 'Call Roadside Assistance',
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              ref.read(sosNotifierProvider.notifier).cancelSOS();
              context.pop();
            },
            child: const Text(
              'Cancel SOS',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatusRow(IconData icon, String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondaryText),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryText)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: valueColor)),
        ],
      ),
    );
  }
}
