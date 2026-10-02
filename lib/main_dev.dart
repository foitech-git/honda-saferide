import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/env_config.dart';
import 'main.dart'; // To get SafeRideApp

final envProvider = Provider<EnvConfig>((ref) => throw UnimplementedError());

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  const env = EnvConfig(
    environment: Environment.dev,
    apiBaseUrl: 'http://localhost:8080/api/v1',
    webSocketUrl: 'ws://localhost:8080/ws',
    enableDeviceSimulator: true,
    enableLogging: true,
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
