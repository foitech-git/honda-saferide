import '../../domain/entities/community/community_report.dart';
import '../../services/map/map_service.dart';

class MockCommunityDataSource {
  final List<CommunityReport> _mockDatabase = [
    CommunityReport(
      id: 'rep_1',
      latitude: 0.002,
      longitude: 0.002,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      type: ReportType.pothole,
      description: 'Deep pothole in the right lane.',
      source: 'SafeRide User',
      verificationStatus: ReportVerification.verifiedByUsers,
      status: ReportStatus.active,
    ),
    CommunityReport(
      id: 'rep_2',
      latitude: -0.001,
      longitude: 0.003,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: ReportType.accident,
      description: 'Minor fender bender blocking left lane.',
      source: 'SafeRide User',
      verificationStatus: ReportVerification.unverified,
      status: ReportStatus.active,
    ),
    CommunityReport(
      id: 'rep_3',
      latitude: 0.004,
      longitude: -0.002,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: ReportType.poorLighting,
      description: 'Street lights are out along this stretch.',
      source: 'SafeRide User',
      verificationStatus: ReportVerification.verifiedByUsers,
      status: ReportStatus.active,
    ),
  ];

  Future<List<CommunityReport>> getNearbyReports({
    required MapCameraPosition location,
    required double radiusMeters,
    List<ReportType>? typeFilters,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network

    if (typeFilters != null && typeFilters.isNotEmpty) {
      return _mockDatabase.where((report) => typeFilters.contains(report.type)).toList();
    }
    return List.from(_mockDatabase);
  }

  Future<CommunityReport> submitReport({
    required ReportType type,
    required double latitude,
    required double longitude,
    String? description,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network

    final newReport = CommunityReport(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      type: type,
      description: description,
      source: 'SafeRide User',
      verificationStatus: ReportVerification.unverified,
      status: ReportStatus.active,
    );
    
    _mockDatabase.add(newReport);
    return newReport;
  }
}
