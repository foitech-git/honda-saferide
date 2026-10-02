import 'package:flutter_test/flutter_test.dart';
import 'package:honda_saferide/domain/entities/community/community_report.dart';
import 'package:honda_saferide/domain/repositories/community_repository.dart';
import 'package:honda_saferide/domain/usecases/community_usecases.dart';
import 'package:honda_saferide/features/community/providers/community_provider.dart';
import 'package:honda_saferide/services/map/map_service.dart';

class FakeCommunityRepository implements CommunityRepository {
  final List<CommunityReport> reports = [
    CommunityReport(
      id: '1',
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now(),
      type: ReportType.pothole,
      source: 'SafeRide User',
      verificationStatus: ReportVerification.unverified,
      status: ReportStatus.active,
    ),
    CommunityReport(
      id: '2',
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now(),
      type: ReportType.accident,
      source: 'SafeRide User',
      verificationStatus: ReportVerification.verifiedByUsers,
      status: ReportStatus.active,
    ),
  ];

  @override
  Future<List<CommunityReport>> getNearbyReports({
    required MapCameraPosition location,
    required double radiusMeters,
    List<ReportType>? typeFilters,
  }) async {
    if (typeFilters != null) {
      return reports.where((r) => typeFilters.contains(r.type)).toList();
    }
    return reports;
  }

  @override
  Future<CommunityReport> submitReport({
    required ReportType type,
    required double latitude,
    required double longitude,
    String? description,
  }) async {
    final report = CommunityReport(
      id: '3',
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      type: type,
      description: description,
      source: 'SafeRide User',
      verificationStatus: ReportVerification.unverified,
      status: ReportStatus.active,
    );
    reports.add(report);
    return report;
  }
}

void main() {
  late CommunityNotifier notifier;
  late FakeCommunityRepository repository;

  setUp(() {
    repository = FakeCommunityRepository();
    final useCases = CommunityUseCases(repository);
    notifier = CommunityNotifier(useCases);
  });

  test('initial state', () {
    expect(notifier.state.isLoading, false);
    expect(notifier.state.reports, isEmpty);
    expect(notifier.state.activeFilter, CommunityFilter.all);
  });

  test('fetchReports without filter gets all reports', () async {
    await notifier.fetchReports(const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14));
    expect(notifier.state.reports.length, 2);
  });

  test('setFilter to accidents only gets accidents', () async {
    notifier.setFilter(
      const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14),
      CommunityFilter.accidents,
    );
    // wait for async
    await Future.delayed(Duration.zero);
    expect(notifier.state.activeFilter, CommunityFilter.accidents);
    expect(notifier.state.reports.length, 1);
    expect(notifier.state.reports.first.type, ReportType.accident);
  });

  test('submitReport adds new report to state if it matches filter', () async {
    await notifier.fetchReports(const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14));
    expect(notifier.state.reports.length, 2);

    final success = await notifier.submitReport(
      type: ReportType.roadWork,
      latitude: 1,
      longitude: 1,
    );

    expect(success, true);
    expect(notifier.state.reports.length, 3);
    expect(notifier.state.reports.last.type, ReportType.roadWork);
  });
}
