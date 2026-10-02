import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/env_config.dart';
import 'main.dart'; // To get SafeRideApp

final envProvider = Provider<EnvConfig>((ref) => throw UnimplementedError());

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  const env = EnvConfig(
    environment: Environment.prod,
    apiBaseUrl: 'https://api.saferide.honda.com/api/v1',
    webSocketUrl: 'wss://api.saferide.honda.com/ws',
    enableDeviceSimulator: false,
    enableLogging: false, // Production-safe logging only
  );

  runApp(
    ProviderScope(
      overrides: [
        envProvider.overrideWithValue(env),
      ],
      child: const SafeRideApp(),
    ),
  );
}
