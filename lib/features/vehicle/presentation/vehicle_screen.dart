import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../core/utils/providers.dart';
import '../../../domain/entities/vehicle.dart';

class VehicleScreen extends ConsumerWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For this demo, we assume the user is 'user_1' and fetch their vehicles.
    final vehiclesAsyncValue = ref.watch(userVehiclesProvider('user_1'));

    return SafeRideScaffold(
      title: 'My Vehicles',
      body: vehiclesAsyncValue.when(
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return const Center(child: Text('No vehicles found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: vehicles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildVehicleCard(vehicles[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    final isHealthy = vehicle.healthStatus == VehicleHealth.good || vehicle.healthStatus == VehicleHealth.excellent;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isHealthy ? AppColors.routeSafe.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(
                  vehicle.type == VehicleType.car
                      ? Icons.directions_car
                      : vehicle.type == VehicleType.motorcycle
                          ? Icons.two_wheeler
                          : Icons.moped,
                  color: isHealthy ? AppColors.routeSafe : AppColors.warning,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      Text(
                        '${vehicle.year} • ${vehicle.registration ?? 'Unregistered'}',
                        style: const TextStyle(color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Manufacturer', vehicle.make),
                const SizedBox(height: 12),
                _buildDetailRow('Model', vehicle.model),
                const SizedBox(height: 12),
                _buildDetailRow('Health Status', _formatHealth(vehicle.healthStatus), 
                  valueColor: isHealthy ? AppColors.success : AppColors.warning),
                const Divider(height: 32, color: AppColors.border),
                
                // Device Info
                Row(
                  children: [
                    const Icon(Icons.router, color: AppColors.secondaryText, size: 20),
                    const SizedBox(width: 8),
                    const Text('SafeRide Device', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryText)),
                    const Spacer(),
                    if (vehicle.deviceId != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Connected', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold)),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryText.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Not Paired', style: TextStyle(color: AppColors.secondaryText, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                if (vehicle.deviceId != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Device ID', style: TextStyle(color: AppColors.secondaryText)),
                      Text(vehicle.deviceId!, style: const TextStyle(color: AppColors.primaryText, fontFamily: 'monospace')),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                SecondaryButton(
                  label: 'Manage Vehicle',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color valueColor = AppColors.primaryText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondaryText)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
        ),
      ],
    );
  }

  String _formatHealth(VehicleHealth health) {
    switch (health) {
      case VehicleHealth.excellent: return 'Excellent';
      case VehicleHealth.good: return 'Good';
      case VehicleHealth.needsAttention: return 'Needs Attention';
      case VehicleHealth.critical: return 'Critical';
    }
  }
}
