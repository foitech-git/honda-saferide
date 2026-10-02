import 'package:flutter_test/flutter_test.dart';
import 'package:honda_saferide/domain/entities/place.dart';
import 'package:honda_saferide/domain/repositories/places_repository.dart';
import 'package:honda_saferide/domain/usecases/places_usecases.dart';
import 'package:honda_saferide/services/map/map_service.dart';

class FakePlacesRepository implements PlacesRepository {
  @override
  Future<List<Place>> getNearbyPlaces({
    required MapCameraPosition location,
    required double radiusMeters,
    PlaceType? typeFilter,
  }) async {
    final allPlaces = [
      Place(
        id: '1',
        name: 'Parking A',
        type: PlaceType.safeParking,
        latitude: 0,
        longitude: 0,
        distanceMeters: 100,
        availability: const PlaceAvailability(isOpen: true),
        ratings: const [PlaceRating(score: 4.0, count: 10, provider: 'SafeRide')],
        reviewSummary: const PlaceReviewSummary(summaryText: '', totalReviews: 0, safeRideVerifiedReviews: 0),
        recentVisits: const [],
        attributes: const [],
      ),
      Place(
        id: '2',
        name: 'EV Station B',
        type: PlaceType.evCharging,
        latitude: 0,
        longitude: 0,
        distanceMeters: 200,
        availability: const PlaceAvailability(isOpen: true),
        ratings: const [PlaceRating(score: 4.5, count: 20, provider: 'SafeRide')],
        reviewSummary: const PlaceReviewSummary(summaryText: '', totalReviews: 0, safeRideVerifiedReviews: 0),
        recentVisits: const [],
        attributes: const [],
      ),
    ];

    if (typeFilter != null) {
      return allPlaces.where((p) => p.type == typeFilter).toList();
    }
    return allPlaces;
  }
}

void main() {
  late PlacesUseCases useCases;
  late FakePlacesRepository repository;

  setUp(() {
    repository = FakePlacesRepository();
    useCases = PlacesUseCases(repository);
  });

  test('returns all places when no filter is applied', () async {
    final places = await useCases.getNearbyPlacesByCategory(
      location: const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14),
      radiusMeters: 1000,
    );
    expect(places.length, 2);
  });

  test('returns filtered places when typeFilter is applied', () async {
    final places = await useCases.getNearbyPlacesByCategory(
      location: const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14),
      radiusMeters: 1000,
      typeFilter: PlaceType.evCharging,
    );
    expect(places.length, 1);
    expect(places.first.type, PlaceType.evCharging);
  });
}
