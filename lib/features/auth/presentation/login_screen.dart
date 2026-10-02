import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/feedback/app_feedback.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;
    if (identifier.isNotEmpty && password.isNotEmpty) {
      ref.read(authNotifierProvider.notifier).login(identifier, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Login failed'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    });

    return SafeRideScaffold(
      title: 'Log In',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 32),
            AppTextField(
              labelText: 'Mobile or Email',
              hintText: 'Enter your mobile number or email',
              controller: _identifierController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            AppTextField(
              labelText: 'Password',
              hintText: 'Enter your password',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push('/forgot-password'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryRed,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 44),
                ),
                child: const Text('Forgot Password?', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Log In',
              isLoading: authState.status == AuthStatus.loading,
              onPressed: _handleLogin,
            ),
          ],
        ),
      ),
    );
  }
}
