import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/feedback/app_feedback.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeRideScaffold(
      title: 'Vehicle Details',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add your vehicle',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 32),
            AppTextField(
              labelText: 'Make',
              hintText: 'e.g., Honda',
              controller: _makeController,
            ),
            const SizedBox(height: 24),
            AppTextField(
              labelText: 'Model',
              hintText: 'e.g., PCX160',
              controller: _modelController,
            ),
            const SizedBox(height: 24),
            AppTextField(
              labelText: 'Year',
              hintText: 'e.g., 2024',
              controller: _yearController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 48),
            AppButton(
              label: 'Continue',
              onPressed: () {
                if (_makeController.text.isNotEmpty && _modelController.text.isNotEmpty) {
                  context.push('/onboarding/device-id');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
