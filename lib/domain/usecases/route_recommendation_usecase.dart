import '../entities/route_option.dart';
import '../repositories/route_repository.dart';
import '../../services/map/map_service.dart';

class RouteRecommendationUseCase {
  final RouteRepository repository;

  RouteRecommendationUseCase(this.repository);

  Future<List<RouteOption>> execute(MapCameraPosition origin, MapCameraPosition destination) async {
    final routes = await repository.getRouteAlternatives(origin, destination);
    
    // Sort or filter routes based on business logic if necessary
    // For now, return the list as provided by the repository
    return routes;
  }
}
