import '../../domain/entities/place.dart';
import '../../domain/repositories/places_repository.dart';
import '../datasources/mock_places_datasource.dart';
import '../../services/map/map_service.dart';
import '../../core/constants/environment.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final MockPlacesDataSource mockDataSource;

  PlacesRepositoryImpl({required this.mockDataSource});

  @override
  Future<List<Place>> getNearbyPlaces({
    required MapCameraPosition location,
    required double radiusMeters,
    PlaceType? typeFilter,
  }) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.getNearbyPlaces(
        location: location,
        radiusMeters: radiusMeters,
        typeFilter: typeFilter,
      );
    }
    throw UnimplementedError('Real Places API not implemented yet');
  }
}
