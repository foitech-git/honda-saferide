import '../entities/community/community_report.dart';
import '../repositories/community_repository.dart';
import '../../services/map/map_service.dart';

class CommunityUseCases {
  final CommunityRepository repository;

  CommunityUseCases(this.repository);

  Future<List<CommunityReport>> getNearbyReports({
    required MapCameraPosition location,
    required double radiusMeters,
    List<ReportType>? typeFilters,
  }) async {
    return await repository.getNearbyReports(
      location: location,
      radiusMeters: radiusMeters,
      typeFilters: typeFilters,
    );
  }

  Future<CommunityReport> submitReport({
    required ReportType type,
    required double latitude,
    required double longitude,
    String? description,
  }) async {
    return await repository.submitReport(
      type: type,
      latitude: latitude,
      longitude: longitude,
      description: description,
    );
  }
}
