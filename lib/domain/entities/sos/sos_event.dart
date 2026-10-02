import 'package:equatable/equatable.dart';

enum SOSStatus { inactive, active }

class EmergencyContact extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String relation;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.relation,
  });

  @override
  List<Object?> get props => [id, name, phone, relation];
}

class SOSEvent extends Equatable {
  final String id;
  final DateTime activatedAt;
  final SOSStatus status;
  final bool isLocationShared;
  final bool isEmergencyServicesNotified;
  final String vehicleStatus; // e.g. 'Stationary', 'Moving'

  const SOSEvent({
    required this.id,
    required this.activatedAt,
    required this.status,
    required this.isLocationShared,
    required this.isEmergencyServicesNotified,
    required this.vehicleStatus,
  });

  @override
  List<Object?> get props => [
        id,
        activatedAt,
        status,
        isLocationShared,
        isEmergencyServicesNotified,
        vehicleStatus,
      ];
}
