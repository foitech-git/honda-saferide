import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/onboarding/presentation/vehicle_type_screen.dart';
import '../../features/onboarding/presentation/add_vehicle_screen.dart';
import '../../features/onboarding/presentation/device_id_screen.dart';
import '../../features/onboarding/presentation/device_connection_screen.dart';
import '../../features/onboarding/presentation/completion_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/sos/presentation/sos_screen.dart';
import '../../features/places/presentation/places_screen.dart';
import '../../features/community/presentation/community_screen.dart';
import '../../features/assist/presentation/assist_screen.dart';
import '../../features/vehicle/presentation/vehicle_screen.dart';
import '../../features/history/presentation/service_history_screen.dart';
import '../../features/history/presentation/parts_record_screen.dart';
import '../../features/simulator/presentation/simulator_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthLoading = authState.status == AuthStatus.loading || authState.status == AuthStatus.initial;
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      
      final isAuthRoute = state.uri.path == '/welcome' || 
                          state.uri.path == '/login' || 
                          state.uri.path == '/signup' || 
                          state.uri.path == '/forgot-password';

      if (isAuthLoading) return null;

      if (!isAuthenticated && !isAuthRoute) {
        return '/welcome';
      }

      if (isAuthenticated && isAuthRoute) {
        // Here we could route to onboarding if they haven't completed it,
        // but for now we route to vehicle-type (first onboarding step) as demo
        // In a real app, this logic would check user's onboarding status.
        return '/onboarding/vehicle-type';
      }

      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot_password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Onboarding Routes
      GoRoute(
        path: '/onboarding/vehicle-type',
        name: 'vehicle_type',
        builder: (context, state) => const VehicleTypeScreen(),
      ),
      GoRoute(
        path: '/onboarding/add-vehicle',
        name: 'add_vehicle',
        builder: (context, state) => const AddVehicleScreen(),
      ),
      GoRoute(
        path: '/onboarding/device-id',
        name: 'device_id',
        builder: (context, state) => const DeviceIdScreen(),
      ),
      GoRoute(
        path: '/onboarding/device-connection',
        name: 'device_connection',
        builder: (context, state) => const DeviceConnectionScreen(),
      ),
      GoRoute(
        path: '/onboarding/completion',
        name: 'completion',
        builder: (context, state) => const CompletionScreen(),
      ),

      // Main App Routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/places',
        name: 'places',
        builder: (context, state) => const PlacesScreen(),
      ),
      GoRoute(
        path: '/community',
        name: 'community',
        builder: (context, state) => const CommunityScreen(),
      ),
      GoRoute(
        path: '/assist',
        name: 'assist',
        builder: (context, state) => const AssistScreen(),
      ),
      GoRoute(
        path: '/vehicle',
        name: 'vehicle',
        builder: (context, state) => const VehicleScreen(),
      ),
      GoRoute(
        path: '/service-history',
        name: 'service-history',
        builder: (context, state) => const ServiceHistoryScreen(),
      ),
      GoRoute(
        path: '/parts-record',
        name: 'parts-record',
        builder: (context, state) => const PartsRecordScreen(),
      ),
      GoRoute(
        path: '/sos',
        name: 'sos',
        builder: (context, state) => const SosScreen(),
      ),
      GoRoute(
        path: '/dev-simulator',
        name: 'dev-simulator',
        builder: (context, state) => const DeviceSimulatorScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri.toString()}'),
      ),
    ),
  );
});
