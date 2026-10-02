import 'package:equatable/equatable.dart';

enum ReportType {
  pothole,
  accident,
  roadWork,
  poorLighting,
  flooding,
  unsafeArea,
  traffic,
  other
}

enum ReportStatus { active, resolved, dismissed }

enum ReportVerification { unverified, verifiedByUsers, verifiedByAuthority }

class CommunityReport extends Equatable {
  final String id;
  final double latitude; // Prepares for PostGIS geometry
  final double longitude;
  final DateTime timestamp;
  final ReportType type;
  final String? description;
  final String source; // E.g., 'SafeRide User' (protects exact identity)
  final ReportVerification verificationStatus;
  final ReportStatus status;

  const CommunityReport({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.type,
    this.description,
    required this.source,
    required this.verificationStatus,
    required this.status,
  });

  String get typeName {
    switch (type) {
      case ReportType.pothole: return 'Pothole';
      case ReportType.accident: return 'Accident';
      case ReportType.roadWork: return 'Road Work';
      case ReportType.poorLighting: return 'Poor Lighting';
      case ReportType.flooding: return 'Flooding';
      case ReportType.unsafeArea: return 'Unsafe Area';
      case ReportType.traffic: return 'Traffic';
      case ReportType.other: return 'Other';
    }
  }

  @override
  List<Object?> get props => [
        id,
        latitude,
        longitude,
        timestamp,
        type,
        description,
        source,
        verificationStatus,
        status,
      ];
}
