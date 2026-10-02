import 'package:flutter/material.dart';
import '../../../domain/entities/place.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/buttons/app_buttons.dart';

class PlaceBottomSheet extends StatelessWidget {
  final Place place;
  final VoidCallback onNavigate;
  final VoidCallback onCancel;

  const PlaceBottomSheet({
    super.key,
    required this.place,
    required this.onNavigate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    IconData typeIcon;
    Color typeColor;

    switch (place.type) {
      case PlaceType.safeParking:
        typeIcon = Icons.local_parking;
        typeColor = AppColors.routeSafe;
        break;
      case PlaceType.evCharging:
        typeIcon = Icons.electric_car;
        typeColor = AppColors.routeWellLit;
        break;
      case PlaceType.fuel:
        typeIcon = Icons.local_gas_station;
        typeColor = AppColors.routeMostUsed;
        break;
    }

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
                  color: typeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(typeIcon, color: typeColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
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
                          place.formattedDistance,
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
                          '${place.averageRating.toStringAsFixed(1)} (${place.totalRatingCount} ratings)',
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
                onPressed: onCancel,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                place.availability.isOpen ? Icons.check_circle : Icons.cancel,
                color: place.availability.isOpen ? AppColors.success : AppColors.danger,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                place.availability.statusText ?? (place.availability.isOpen ? 'Open' : 'Closed'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: place.availability.isOpen ? AppColors.success : AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: place.attributes.map((attr) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  attr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Navigate',
            onPressed: onNavigate,
          ),
        ],
      ),
    );
  }
}
