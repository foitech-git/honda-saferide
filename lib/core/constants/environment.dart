enum EnvironmentType { dev, staging, prod }

class Environment {
  final EnvironmentType type;
  final String apiUrl;
  final String mapApiKey;
  final bool useMockData;

  const Environment({
    required this.type,
    required this.apiUrl,
    required this.mapApiKey,
    required this.useMockData,
  });

  static Environment get current {
    // In a real app, this would be populated from flutter_dotenv or dart-defines
    return const Environment(
      type: EnvironmentType.dev,
      apiUrl: 'https://api.dev.honda-saferide.com',
      mapApiKey: 'MOCK_GOOGLE_MAPS_KEY',
      useMockData: true, // IMPORTANT: The app must initially work WITHOUT a real backend.
    );
  }
}
