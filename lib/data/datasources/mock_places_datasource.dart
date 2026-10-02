import '../../domain/entities/place.dart';
import '../../services/map/map_service.dart';

class MockPlacesDataSource {
  Future<List<Place>> getNearbyPlaces({
    required MapCameraPosition location,
    required double radiusMeters,
    PlaceType? typeFilter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network

    final allPlaces = [
      Place(
        id: 'p1',
        name: 'City Center Secure Parking',
        type: PlaceType.safeParking,
        latitude: location.latitude + 0.001,
        longitude: location.longitude + 0.001,
        distanceMeters: 450,
        availability: const PlaceAvailability(isOpen: true, statusText: 'Open • Closes at 11 PM'),
        ratings: const [
          PlaceRating(score: 4.8, count: 124, provider: 'SafeRide'),
          PlaceRating(score: 4.5, count: 850, provider: 'Google'),
        ],
        reviewSummary: const PlaceReviewSummary(
          summaryText: 'Highly rated for security and lighting.',
          totalReviews: 974,
          safeRideVerifiedReviews: 89,
        ),
        recentVisits: [
          PlaceVisit(userId: 'u1', visitDate: DateTime.now().subtract(const Duration(days: 1)), verified: true),
        ],
        attributes: const ['Security Cameras', 'Well-lit', 'Guarded'],
      ),
      Place(
        id: 'p2',
        name: 'Honda Fast Charge Station',
        type: PlaceType.evCharging,
        latitude: location.latitude - 0.002,
        longitude: location.longitude + 0.002,
        distanceMeters: 850,
        availability: const PlaceAvailability(isOpen: true, statusText: 'Available (2/4 plugs)'),
        ratings: const [
          PlaceRating(score: 4.9, count: 56, provider: 'SafeRide'),
        ],
        reviewSummary: const PlaceReviewSummary(
          summaryText: 'Fast and reliable charging.',
          totalReviews: 56,
          safeRideVerifiedReviews: 45,
        ),
        recentVisits: [],
        attributes: const ['DC Fast Charge', 'CCS2', 'Restroom nearby'],
      ),
      Place(
        id: 'p3',
        name: 'Express Fuel & Mart',
        type: PlaceType.fuel,
        latitude: location.latitude + 0.003,
        longitude: location.longitude - 0.001,
        distanceMeters: 1200,
        availability: const PlaceAvailability(isOpen: true, statusText: 'Open 24/7'),
        ratings: const [
          PlaceRating(score: 4.2, count: 328, provider: 'SafeRide'),
        ],
        reviewSummary: const PlaceReviewSummary(
          summaryText: 'Convenient 24/7 access.',
          totalReviews: 328,
          safeRideVerifiedReviews: 120,
        ),
        recentVisits: [],
        attributes: const ['24/7', 'Convenience Store', 'Air & Water'],
      ),
    ];

    if (typeFilter != null) {
      return allPlaces.where((p) => p.type == typeFilter).toList();
    }
    return allPlaces;
  }
}
