import '../../domain/entities/route_option.dart';
import '../../domain/repositories/route_repository.dart';
import '../datasources/mock_route_datasource.dart';
import '../../services/map/map_service.dart';
import '../../core/constants/environment.dart';

class RouteRepositoryImpl implements RouteRepository {
  final MockRouteDataSource mockDataSource;

  RouteRepositoryImpl({required this.mockDataSource});

  @override
  Future<List<RouteOption>> getRouteAlternatives(MapCameraPosition origin, MapCameraPosition destination) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.getRouteAlternatives(origin, destination);
    }
    throw UnimplementedError('Real API not implemented yet');
  }
}
