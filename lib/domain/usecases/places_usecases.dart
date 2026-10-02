import '../entities/place.dart';
import '../repositories/places_repository.dart';
import '../../services/map/map_service.dart';

class PlacesUseCases {
  final PlacesRepository repository;

  PlacesUseCases(this.repository);

  Future<List<Place>> getNearbyPlacesByCategory({
    required MapCameraPosition location,
    required double radiusMeters,
    PlaceType? typeFilter,
  }) async {
    return await repository.getNearbyPlaces(
      location: location,
      radiusMeters: radiusMeters,
      typeFilter: typeFilter,
    );
  }
}
