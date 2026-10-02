import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/feedback/app_feedback.dart';
import '../providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    final name = _nameController.text.trim();
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;
    if (name.isNotEmpty && identifier.isNotEmpty && password.isNotEmpty) {
      ref.read(authNotifierProvider.notifier).signUp(name, identifier, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Signup failed'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    });

    return SafeRideScaffold(
      title: 'Create Account',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Join SafeRide',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fill in your details to get started.',
              style: TextStyle(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 32),
            AppTextField(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              controller: _nameController,
            ),
            const SizedBox(height: 24),
            AppTextField(
              labelText: 'Mobile or Email',
              hintText: 'Enter your mobile number or email',
              controller: _identifierController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            AppTextField(
              labelText: 'Password',
              hintText: 'Create a password',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 48),
            AppButton(
              label: 'Create Account',
              isLoading: authState.status == AuthStatus.loading,
              onPressed: _handleSignUp,
            ),
          ],
        ),
      ),
    );
  }
}
