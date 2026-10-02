import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/route_option.dart';
import '../../../domain/usecases/route_recommendation_usecase.dart';
import '../../../core/utils/providers.dart';
import '../../../services/map/map_service.dart';

class RouteState {
  final bool isLoading;
  final List<RouteOption> availableRoutes;
  final RouteOption? selectedRoute;
  final String? errorMessage;

  const RouteState({
    this.isLoading = false,
    this.availableRoutes = const [],
    this.selectedRoute,
    this.errorMessage,
  });

  RouteState copyWith({
    bool? isLoading,
    List<RouteOption>? availableRoutes,
    RouteOption? selectedRoute,
    String? errorMessage,
  }) {
    return RouteState(
      isLoading: isLoading ?? this.isLoading,
      availableRoutes: availableRoutes ?? this.availableRoutes,
      selectedRoute: selectedRoute, // Allow nullification if explicitly passed (not easily possible with this simple copyWith, but sufficient for now. We'll handle deselecting separately if needed).
      errorMessage: errorMessage,
    );
  }

  RouteState clearSelectedRoute() {
    return RouteState(
      isLoading: isLoading,
      availableRoutes: availableRoutes,
      selectedRoute: null,
      errorMessage: errorMessage,
    );
  }
}

class RouteNotifier extends StateNotifier<RouteState> {
  final RouteRecommendationUseCase _useCase;

  RouteNotifier(this._useCase) : super(const RouteState());

  Future<void> fetchRoutes(MapCameraPosition origin, MapCameraPosition destination) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final routes = await _useCase.execute(origin, destination);
      state = state.copyWith(
        isLoading: false,
        availableRoutes: routes,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void selectRouteByType(RouteType type) {
    try {
      final selected = state.availableRoutes.firstWhere((route) => route.type == type);
      state = state.copyWith(selectedRoute: selected);
    } catch (e) {
      // Route type not found in available routes
      state = state.copyWith(errorMessage: 'Route type not available');
    }
  }

  void clearSelection() {
    state = state.clearSelectedRoute();
  }
}

final routeNotifierProvider = StateNotifierProvider<RouteNotifier, RouteState>((ref) {
  final useCase = ref.watch(routeRecommendationUseCaseProvider);
  return RouteNotifier(useCase);
});
