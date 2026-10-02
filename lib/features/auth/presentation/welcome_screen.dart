import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeRideScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            // Logo placeholder
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.two_wheeler, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 32),
            const Text(
              'Honda SafeRide',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Safer journeys. Smarter assistance.',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.secondaryText,
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Log In',
              onPressed: () => context.push('/login'),
            ),
            const SizedBox(height: 16),
            SecondaryButton(
              label: 'Create Account',
              onPressed: () => context.push('/signup'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
