import 'package:equatable/equatable.dart';

enum VehicleType { car, motorcycle, scooter, truck, other }

enum VehicleHealth { excellent, good, needsAttention, critical }

class Vehicle extends Equatable {
  final String id;
  final String make; // Manufacturer
  final String model;
  final int year;
  final VehicleType type;
  final String? registration;
  final double fuelLevel; // 0.0 to 1.0
  final double batteryLevel; // 0.0 to 1.0
  final String? deviceId; // Reference to the connected Device
  final VehicleHealth healthStatus;

  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.type,
    this.registration,
    required this.fuelLevel,
    required this.batteryLevel,
    this.deviceId,
    this.healthStatus = VehicleHealth.good,
  });

  String get displayName => '$make $model';

  @override
  List<Object?> get props => [
        id,
        make,
        model,
        year,
        type,
        registration,
        fuelLevel,
        batteryLevel,
        deviceId,
        healthStatus,
      ];
}
