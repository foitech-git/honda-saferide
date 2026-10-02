import '../../domain/entities/route_option.dart';
import '../../services/map/map_service.dart';

class MockRouteDataSource {
  Future<List<RouteOption>> getRouteAlternatives(MapCameraPosition origin, MapCameraPosition destination) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network

    return [
      const RouteOption(
        id: 'r_safe',
        name: 'Safe Route',
        type: RouteType.safe,
        metrics: RouteMetrics(distanceMeters: 12500, durationSeconds: 1500), // 12.5km, 25min
        signals: RouteSafetySignals(
          roadConditions: 'Clear',
          incidents: 0,
          lighting: 'Excellent',
          userFeedbackScore: 4.9,
        ),
        geometry: [],
      ),
      const RouteOption(
        id: 'r_well_lit',
        name: 'Well-Lit Route',
        type: RouteType.wellLit,
        metrics: RouteMetrics(distanceMeters: 14000, durationSeconds: 1680), // 14km, 28min
        signals: RouteSafetySignals(
          roadConditions: 'Clear',
          incidents: 1,
          lighting: 'Optimal (100% covered)',
          userFeedbackScore: 4.7,
        ),
        geometry: [],
      ),
      const RouteOption(
        id: 'r_most_used',
        name: 'Most Used',
        type: RouteType.mostUsed,
        metrics: RouteMetrics(distanceMeters: 11000, durationSeconds: 1200), // 11km, 20min
        signals: RouteSafetySignals(
          roadConditions: 'Moderate Traffic',
          incidents: 2,
          lighting: 'Partial',
          userFeedbackScore: 4.5,
        ),
        geometry: [],
      ),
    ];
  }
}
