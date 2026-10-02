import '../entities/route_option.dart';
import '../../services/map/map_service.dart';

abstract class RouteRepository {
  Future<List<RouteOption>> getRouteAlternatives(MapCameraPosition origin, MapCameraPosition destination);
}
