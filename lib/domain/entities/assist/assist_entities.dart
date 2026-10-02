import 'package:equatable/equatable.dart';

enum ServiceType { roadsideAssistance, vehicleRepair, tyre, battery }

enum AssistanceStatus { idle, requested, accepted, providerEnRoute, arrived, completed, cancelled }

class ServiceProvider extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final List<ServiceType> supportedServices;
  final List<String> supportedVehicleTypes; // 'Car', 'Motorcycle', 'Scooter', 'Truck'
  final double rating;
  final int ratingCount;
  final bool isOpen;

  const ServiceProvider({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.supportedServices,
    required this.supportedVehicleTypes,
    required this.rating,
    required this.ratingCount,
    required this.isOpen,
  });

  String get formattedDistance => distanceMeters < 1000 
      ? '${distanceMeters.round()} m' 
      : '${(distanceMeters / 1000).toStringAsFixed(1)} km';

  @override
  List<Object?> get props => [
        id, name, latitude, longitude, distanceMeters, 
        supportedServices, supportedVehicleTypes, rating, ratingCount, isOpen
      ];
}

class AssistanceRequest extends Equatable {
  final String id;
  final String providerId;
  final ServiceType serviceType;
  final AssistanceStatus status;
  final DateTime timestamp;

  const AssistanceRequest({
    required this.id,
    required this.providerId,
    required this.serviceType,
    required this.status,
    required this.timestamp,
  });

  AssistanceRequest copyWith({
    String? id,
    String? providerId,
    ServiceType? serviceType,
    AssistanceStatus? status,
    DateTime? timestamp,
  }) {
    return AssistanceRequest(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      serviceType: serviceType ?? this.serviceType,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [id, providerId, serviceType, status, timestamp];
}
