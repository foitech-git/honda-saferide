import 'package:equatable/equatable.dart';

enum PlaceType { safeParking, evCharging, fuel }

class PlaceRating extends Equatable {
  final double score;
  final int count;
  final String provider; // e.g., 'SafeRide', 'Google', 'Yelp'

  const PlaceRating({
    required this.score,
    required this.count,
    required this.provider,
  });

  @override
  List<Object?> get props => [score, count, provider];
}

class PlaceReviewSummary extends Equatable {
  final String summaryText;
  final int totalReviews;
  final int safeRideVerifiedReviews;

  const PlaceReviewSummary({
    required this.summaryText,
    required this.totalReviews,
    required this.safeRideVerifiedReviews,
  });

  @override
  List<Object?> get props => [summaryText, totalReviews, safeRideVerifiedReviews];
}

class PlaceAvailability extends Equatable {
  final bool isOpen;
  final String? statusText; // e.g., 'Closes at 10 PM', 'Available (3/4 slots)'

  const PlaceAvailability({
    required this.isOpen,
    this.statusText,
  });

  @override
  List<Object?> get props => [isOpen, statusText];
}

class PlaceVisit extends Equatable {
  final String userId;
  final DateTime visitDate;
  final bool verified;

  const PlaceVisit({
    required this.userId,
    required this.visitDate,
    required this.verified,
  });

  @override
  List<Object?> get props => [userId, visitDate, verified];
}

class Place extends Equatable {
  final String id;
  final String? externalPlaceId; // For third-party provider integrations
  final String name;
  final PlaceType type;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final PlaceAvailability availability;
  final List<PlaceRating> ratings;
  final PlaceReviewSummary reviewSummary;
  final List<PlaceVisit> recentVisits;
  final List<String> attributes; // e.g., ['Covered Parking', 'Security Cameras']

  const Place({
    required this.id,
    this.externalPlaceId,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.availability,
    required this.ratings,
    required this.reviewSummary,
    required this.recentVisits,
    required this.attributes,
  });

  String get formattedDistance => distanceMeters < 1000 
      ? '${distanceMeters.round()} m' 
      : '${(distanceMeters / 1000).toStringAsFixed(1)} km';

  double get averageRating {
    if (ratings.isEmpty) return 0.0;
    // Prefer SafeRide rating if available, else fallback
    final srRating = ratings.where((r) => r.provider == 'SafeRide').firstOrNull;
    return srRating?.score ?? ratings.first.score;
  }

  int get totalRatingCount {
    return ratings.fold(0, (sum, rating) => sum + rating.count);
  }

  @override
  List<Object?> get props => [
        id,
        externalPlaceId,
        name,
        type,
        latitude,
        longitude,
        distanceMeters,
        availability,
        ratings,
        reviewSummary,
        recentVisits,
        attributes,
      ];
}
