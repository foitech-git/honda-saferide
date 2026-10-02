import '../entities/community/community_report.dart';
import '../../services/map/map_service.dart';

abstract class CommunityRepository {
  Future<List<CommunityReport>> getNearbyReports({
    required MapCameraPosition location,
    required double radiusMeters,
    List<ReportType>? typeFilters,
  });

  Future<CommunityReport> submitReport({
    required ReportType type,
    required double latitude,
    required double longitude,
    String? description,
  });
}
