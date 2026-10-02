import '../../domain/entities/community/community_report.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/mock_community_datasource.dart';
import '../../services/map/map_service.dart';
import '../../core/constants/environment.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final MockCommunityDataSource mockDataSource;

  CommunityRepositoryImpl({required this.mockDataSource});

  @override
  Future<List<CommunityReport>> getNearbyReports({
    required MapCameraPosition location,
    required double radiusMeters,
    List<ReportType>? typeFilters,
  }) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.getNearbyReports(
        location: location,
        radiusMeters: radiusMeters,
        typeFilters: typeFilters,
      );
    }
    throw UnimplementedError('Real Community API not implemented yet');
  }

  @override
  Future<CommunityReport> submitReport({
    required ReportType type,
    required double latitude,
    required double longitude,
    String? description,
  }) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.submitReport(
        type: type,
        latitude: latitude,
        longitude: longitude,
        description: description,
      );
    }
    throw UnimplementedError('Real Community API not implemented yet');
  }
}
