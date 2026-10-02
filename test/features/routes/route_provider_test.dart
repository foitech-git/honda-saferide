import 'package:flutter_test/flutter_test.dart';
import 'package:honda_saferide/domain/entities/route_option.dart';
import 'package:honda_saferide/features/routes/providers/route_provider.dart';
import 'package:honda_saferide/domain/repositories/route_repository.dart';
import 'package:honda_saferide/domain/usecases/route_recommendation_usecase.dart';
import 'package:honda_saferide/services/map/map_service.dart';

class FakeRouteRepository implements RouteRepository {
  @override
  Future<List<RouteOption>> getRouteAlternatives(MapCameraPosition origin, MapCameraPosition destination) async {
    return [
      const RouteOption(
        id: 'r_safe',
        name: 'Safe Route',
        type: RouteType.safe,
        metrics: RouteMetrics(distanceMeters: 10000, durationSeconds: 1200),
        signals: RouteSafetySignals(roadConditions: 'Clear', incidents: 0, lighting: 'Good', userFeedbackScore: 5.0),
        geometry: [],
      ),
      const RouteOption(
        id: 'r_well_lit',
        name: 'Well-Lit Route',
        type: RouteType.wellLit,
        metrics: RouteMetrics(distanceMeters: 12000, durationSeconds: 1500),
        signals: RouteSafetySignals(roadConditions: 'Clear', incidents: 0, lighting: 'Excellent', userFeedbackScore: 4.8),
        geometry: [],
      ),
    ];
  }
}

void main() {
  late RouteNotifier notifier;

  setUp(() {
    final repository = FakeRouteRepository();
    final useCase = RouteRecommendationUseCase(repository);
    notifier = RouteNotifier(useCase);
  });

  test('initial state is empty and not loading', () {
    expect(notifier.state.isLoading, false);
    expect(notifier.state.availableRoutes, isEmpty);
    expect(notifier.state.selectedRoute, isNull);
  });

  test('fetchRoutes populates availableRoutes', () async {
    const pos = MapCameraPosition(latitude: 0, longitude: 0, zoom: 10);
    
    await notifier.fetchRoutes(pos, pos);
    
    expect(notifier.state.isLoading, false);
    expect(notifier.state.availableRoutes.length, 2);
  });

  test('selectRouteByType sets the selectedRoute correctly', () async {
    const pos = MapCameraPosition(latitude: 0, longitude: 0, zoom: 10);
    await notifier.fetchRoutes(pos, pos);
    
    notifier.selectRouteByType(RouteType.wellLit);
    
    expect(notifier.state.selectedRoute, isNotNull);
    expect(notifier.state.selectedRoute!.type, RouteType.wellLit);
  });

  test('clearSelection clears the selected route', () async {
    const pos = MapCameraPosition(latitude: 0, longitude: 0, zoom: 10);
    await notifier.fetchRoutes(pos, pos);
    
    notifier.selectRouteByType(RouteType.safe);
    expect(notifier.state.selectedRoute, isNotNull);
    
    notifier.clearSelection();
    expect(notifier.state.selectedRoute, isNull);
    // availableRoutes should remain
    expect(notifier.state.availableRoutes.isNotEmpty, true);
  });
}
