import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/feedback/app_feedback.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _identifierController = TextEditingController();
  bool _isSubmitted = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_identifierController.text.isNotEmpty) {
      setState(() {
        _isSubmitted = true;
      });
      // Future: connect to auth repository reset logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeRideScaffold(
      title: 'Reset Password',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isSubmitted
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 64, color: AppColors.success),
                  const SizedBox(height: 24),
                  const Text(
                    'Check your inbox',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We have sent password reset instructions to your contact method.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 48),
                  AppButton(
                    label: 'Return to Login',
                    onPressed: () => context.go('/login'),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Forgot your password?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your mobile number or email and we will send you instructions to reset it.',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    labelText: 'Mobile or Email',
                    hintText: 'Enter your mobile number or email',
                    controller: _identifierController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: 'Send Instructions',
                    onPressed: _handleSubmit,
                  ),
                ],
              ),
      ),
    );
  }
}
