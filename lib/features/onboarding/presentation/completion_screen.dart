import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeRideScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Icon(Icons.check_circle, size: 80, color: AppColors.success),
            const SizedBox(height: 32),
            const Text(
              'You\'re all set!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your vehicle and device are connected. You can now use Honda SafeRide features.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.secondaryText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            AppButton(
              label: 'Go to Dashboard',
              onPressed: () => context.go('/'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
