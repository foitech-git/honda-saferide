import 'package:flutter_test/flutter_test.dart';
import 'package:honda_saferide/domain/entities/route_option.dart';
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
  late RouteRecommendationUseCase useCase;
  late FakeRouteRepository repository;

  setUp(() {
    repository = FakeRouteRepository();
    useCase = RouteRecommendationUseCase(repository);
  });

  test('RouteRecommendationUseCase returns route alternatives', () async {
    // Arrange
    const origin = MapCameraPosition(latitude: 0, longitude: 0, zoom: 10);
    const dest = MapCameraPosition(latitude: 1, longitude: 1, zoom: 10);

    // Act
    final routes = await useCase.execute(origin, dest);

    // Assert
    expect(routes.length, 2);
    expect(routes[0].type, RouteType.safe);
    expect(routes[1].type, RouteType.wellLit);
  });
}
