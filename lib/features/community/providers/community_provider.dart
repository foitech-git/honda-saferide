import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/community/community_report.dart';
import '../../../domain/usecases/community_usecases.dart';
import '../../../core/utils/providers.dart';
import '../../../services/map/map_service.dart';

enum CommunityFilter { all, hazards, accidents, traffic, safety }

class CommunityState {
  final bool isLoading;
  final bool isSubmitting;
  final List<CommunityReport> reports;
  final CommunityFilter activeFilter;
  final String? errorMessage;

  const CommunityState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.reports = const [],
    this.activeFilter = CommunityFilter.all,
    this.errorMessage,
  });

  CommunityState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<CommunityReport>? reports,
    CommunityFilter? activeFilter,
    String? errorMessage,
  }) {
    return CommunityState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      reports: reports ?? this.reports,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: errorMessage, // We typically want to clear it if not passed, but we'll leave it as is. Usually passing null clears it if we design it that way, but let's just use it simply.
    );
  }

  CommunityState clearError() {
    return CommunityState(
      isLoading: isLoading,
      isSubmitting: isSubmitting,
      reports: reports,
      activeFilter: activeFilter,
      errorMessage: null,
    );
  }
}

class CommunityNotifier extends StateNotifier<CommunityState> {
  final CommunityUseCases _useCases;

  CommunityNotifier(this._useCases) : super(const CommunityState());

  List<ReportType>? _mapFilterToTypes(CommunityFilter filter) {
    switch (filter) {
      case CommunityFilter.hazards:
        return [ReportType.pothole, ReportType.roadWork, ReportType.flooding, ReportType.other];
      case CommunityFilter.accidents:
        return [ReportType.accident];
      case CommunityFilter.traffic:
        return [ReportType.traffic];
      case CommunityFilter.safety:
        return [ReportType.poorLighting, ReportType.unsafeArea];
      case CommunityFilter.all:
        return null;
    }
  }

  Future<void> fetchReports(MapCameraPosition location, {CommunityFilter filter = CommunityFilter.all}) async {
    state = state.copyWith(isLoading: true, activeFilter: filter).clearError();
    try {
      final types = _mapFilterToTypes(filter);
      final reports = await _useCases.getNearbyReports(
        location: location,
        radiusMeters: 5000,
        typeFilters: types,
      );
      state = state.copyWith(isLoading: false, reports: reports);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setFilter(MapCameraPosition location, CommunityFilter filter) {
    // If same filter clicked, revert to all
    final newFilter = state.activeFilter == filter ? CommunityFilter.all : filter;
    fetchReports(location, filter: newFilter);
  }

  Future<bool> submitReport({
    required ReportType type,
    required double latitude,
    required double longitude,
    String? description,
  }) async {
    state = state.copyWith(isSubmitting: true).clearError();
    try {
      final newReport = await _useCases.submitReport(
        type: type,
        latitude: latitude,
        longitude: longitude,
        description: description,
      );
      
      // Update local state by adding the new report if it matches the current filter
      final types = _mapFilterToTypes(state.activeFilter);
      if (types == null || types.contains(newReport.type)) {
        state = state.copyWith(
          isSubmitting: false,
          reports: [...state.reports, newReport],
        );
      } else {
        state = state.copyWith(isSubmitting: false);
      }
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }
}

final communityNotifierProvider = StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  final useCases = ref.watch(communityUseCasesProvider);
  return CommunityNotifier(useCases);
});
