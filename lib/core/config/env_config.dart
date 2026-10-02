enum Environment { dev, stg, prod }

class EnvConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String webSocketUrl;
  final bool enableDeviceSimulator;
  final bool enableLogging;

  const EnvConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.webSocketUrl,
    required this.enableDeviceSimulator,
    required this.enableLogging,
  });

  bool get isProduction => environment == Environment.prod;
  bool get isDevelopment => environment == Environment.dev;
}
