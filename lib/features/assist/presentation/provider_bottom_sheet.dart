import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../domain/entities/assist/assist_entities.dart';
import '../providers/assist_provider.dart';

class ProviderBottomSheet extends ConsumerWidget {
  final ServiceProvider provider;

  const ProviderBottomSheet({super.key, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.routeMostUsed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.handyman, color: AppColors.routeMostUsed, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          provider.formattedDistance,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.star, color: AppColors.routeWellLit, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${provider.rating} (${provider.ratingCount})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ref.read(assistNotifierProvider.notifier).clearSelection();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                provider.isOpen ? Icons.check_circle : Icons.cancel,
                color: provider.isOpen ? AppColors.success : AppColors.danger,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                provider.isOpen ? 'Available Now' : 'Currently Unavailable',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: provider.isOpen ? AppColors.success : AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: provider.supportedServices.map((service) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  _getServiceName(service),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Call',
                  icon: Icons.phone,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: AppButton(
                  label: 'Request Help',
                  onPressed: provider.isOpen
                      ? () {
                          // Default to requesting the first supported service for now
                          ref.read(assistNotifierProvider.notifier).requestAssistance(
                                provider,
                                provider.supportedServices.first,
                              );
                          Navigator.of(context).pop();
                        }
                      : null, // Disabled if closed
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getServiceName(ServiceType type) {
    switch (type) {
      case ServiceType.roadsideAssistance:
        return 'Roadside Assistance';
      case ServiceType.vehicleRepair:
        return 'Vehicle Repair';
      case ServiceType.tyre:
        return 'Tyre Service';
      case ServiceType.battery:
        return 'Battery Service';
    }
  }
}
