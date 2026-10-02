import '../entities/place.dart';
import '../../services/map/map_service.dart';

abstract class PlacesRepository {
  Future<List<Place>> getNearbyPlaces({
    required MapCameraPosition location,
    required double radiusMeters,
    PlaceType? typeFilter,
  });
}
