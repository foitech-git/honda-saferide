import 'package:equatable/equatable.dart';

enum ServiceStatus { pending, inProgress, completed, cancelled }

class ServiceRecord extends Equatable {
  final String id;
  final String vehicleId;
  final String title; // e.g., 'Periodic Service', 'Brake Inspection'
  final DateTime date;
  final ServiceStatus status;
  final String? providerName;
  final int? mileage;
  final String? notes;
  final String? documentUrl;

  const ServiceRecord({
    required this.id,
    required this.vehicleId,
    required this.title,
    required this.date,
    required this.status,
    this.providerName,
    this.mileage,
    this.notes,
    this.documentUrl,
  });

  @override
  List<Object?> get props => [
        id, vehicleId, title, date, status, 
        providerName, mileage, notes, documentUrl
      ];
}

class PartRecord extends Equatable {
  final String id;
  final String vehicleId;
  final String partName; // e.g., 'Brake Pads', 'Battery'
  final String manufacturer;
  final DateTime installationDate;
  final DateTime? replacementDate; // Null if currently installed
  final int mileageAtInstall;
  final String serviceProvider;
  final String? notes;
  final String? documentUrl;

  const PartRecord({
    required this.id,
    required this.vehicleId,
    required this.partName,
    required this.manufacturer,
    required this.installationDate,
    this.replacementDate,
    required this.mileageAtInstall,
    required this.serviceProvider,
    this.notes,
    this.documentUrl,
  });

  @override
  List<Object?> get props => [
        id, vehicleId, partName, manufacturer, installationDate,
        replacementDate, mileageAtInstall, serviceProvider, notes, documentUrl
      ];
}
