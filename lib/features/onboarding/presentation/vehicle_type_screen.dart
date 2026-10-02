import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/data_display/app_data_display.dart';

class VehicleTypeScreen extends StatefulWidget {
  const VehicleTypeScreen({super.key});

  @override
  State<VehicleTypeScreen> createState() => _VehicleTypeScreenState();
}

class _VehicleTypeScreenState extends State<VehicleTypeScreen> {
  String? _selectedType;

  final List<Map<String, dynamic>> _vehicleTypes = [
    {'type': 'Car', 'icon': Icons.directions_car},
    {'type': 'Motorcycle', 'icon': Icons.motorcycle},
    {'type': 'Scooter', 'icon': Icons.two_wheeler},
    {'type': 'Truck', 'icon': Icons.local_shipping},
    {'type': 'Other', 'icon': Icons.commute},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeRideScaffold(
      title: 'Vehicle Setup',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'What do you ride?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select your primary vehicle type.',
              style: TextStyle(color: AppColors.secondaryText),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: _vehicleTypes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _vehicleTypes[index];
                  final isSelected = _selectedType == item['type'];
                  
                  return AppCard(
                    backgroundColor: isSelected ? AppColors.primaryRed.withOpacity(0.05) : AppColors.surface,
                    onTap: () {
                      setState(() {
                        _selectedType = item['type'] as String;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color: isSelected ? AppColors.primaryRed : AppColors.primaryText,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          item['type'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primaryRed : AppColors.primaryText,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: AppColors.primaryRed),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Continue',
              onPressed: _selectedType != null ? () => context.push('/onboarding/add-vehicle') : null,
            ),
          ],
        ),
      ),
    );
  }
}
