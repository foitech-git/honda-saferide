import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/feedback/app_feedback.dart';

class DeviceIdScreen extends StatefulWidget {
  const DeviceIdScreen({super.key});

  @override
  State<DeviceIdScreen> createState() => _DeviceIdScreenState();
}

class _DeviceIdScreenState extends State<DeviceIdScreen> {
  final _deviceIdController = TextEditingController();

  @override
  void dispose() {
    _deviceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeRideScaffold(
      title: 'Connect Device',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.qr_code_scanner, size: 64, color: AppColors.primaryRed),
            const SizedBox(height: 24),
            const Text(
              'Link your SafeRide Device',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter the Device ID found on your hardware unit, or scan the QR code.',
              style: TextStyle(color: AppColors.secondaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppTextField(
              labelText: 'Device ID',
              hintText: 'e.g., HSR-DEV-000001',
              controller: _deviceIdController,
            ),
            const SizedBox(height: 16),
            SecondaryButton(
              label: 'Scan QR Code',
              icon: Icons.camera_alt,
              onPressed: () {
                // Mock QR scan result
                setState(() {
                  _deviceIdController.text = 'HSR-DEV-000001';
                });
              },
            ),
            const Spacer(),
            AppButton(
              label: 'Connect Device',
              onPressed: () {
                if (_deviceIdController.text.isNotEmpty) {
                  context.push('/onboarding/device-connection');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
