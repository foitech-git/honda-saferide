import 'package:flutter_test/flutter_test.dart';
import 'package:honda_saferide/domain/entities/place.dart';
import 'package:honda_saferide/domain/repositories/places_repository.dart';
import 'package:honda_saferide/domain/usecases/places_usecases.dart';
import 'package:honda_saferide/features/places/providers/places_provider.dart';
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
  late PlacesNotifier notifier;

  setUp(() {
    final repository = FakePlacesRepository();
    final useCases = PlacesUseCases(repository);
    notifier = PlacesNotifier(useCases);
  });

  test('initial state is correct', () {
    expect(notifier.state.isLoading, false);
    expect(notifier.state.places, isEmpty);
    expect(notifier.state.activeFilter, isNull);
    expect(notifier.state.selectedPlace, isNull);
  });

  test('fetchNearbyPlaces populates places', () async {
    await notifier.fetchNearbyPlaces(const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14));
    expect(notifier.state.isLoading, false);
    expect(notifier.state.places.length, 2);
  });

  test('applyFilter toggles filter correctly', () async {
    const loc = MapCameraPosition(latitude: 0, longitude: 0, zoom: 14);
    
    // Apply EV Charging
    await notifier.fetchNearbyPlaces(loc, filter: PlaceType.evCharging);
    expect(notifier.state.activeFilter, PlaceType.evCharging);
    expect(notifier.state.places.length, 1);

    // Apply EV Charging again (should toggle off in real UI via applyFilter, let's call applyFilter)
    notifier.applyFilter(loc, PlaceType.evCharging);
    // Wait for the async operation to complete inside applyFilter
    await Future.delayed(Duration.zero);
    expect(notifier.state.activeFilter, isNull);
    expect(notifier.state.places.length, 2);
  });

  test('selectPlace updates state', () async {
    await notifier.fetchNearbyPlaces(const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14));
    final place = notifier.state.places.first;
    
    notifier.selectPlace(place);
    expect(notifier.state.selectedPlace, isNotNull);
    expect(notifier.state.selectedPlace!.id, place.id);

    notifier.clearSelection();
    expect(notifier.state.selectedPlace, isNull);
  });
}
