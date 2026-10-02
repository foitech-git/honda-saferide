import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/assist/assist_entities.dart';
import '../../../domain/usecases/assist_usecases.dart';
import '../../../core/utils/providers.dart';
import '../../../services/map/map_service.dart';

class AssistState {
  final bool isLoading;
  final List<ServiceProvider> providers;
  final ServiceProvider? selectedProvider;
  final ServiceType? activeCategory;
  final AssistanceRequest? activeRequest;
  final String? errorMessage;

  const AssistState({
    this.isLoading = false,
    this.providers = const [],
    this.selectedProvider,
    this.activeCategory,
    this.activeRequest,
    this.errorMessage,
  });

  AssistState copyWith({
    bool? isLoading,
    List<ServiceProvider>? providers,
    ServiceProvider? selectedProvider,
    ServiceType? activeCategory,
    AssistanceRequest? activeRequest,
    String? errorMessage,
  }) {
    return AssistState(
      isLoading: isLoading ?? this.isLoading,
      providers: providers ?? this.providers,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      activeCategory: activeCategory ?? this.activeCategory,
      activeRequest: activeRequest ?? this.activeRequest,
      errorMessage: errorMessage,
    );
  }

  AssistState clearSelectedProvider() {
    return AssistState(
      isLoading: isLoading,
      providers: providers,
      selectedProvider: null,
      activeCategory: activeCategory,
      activeRequest: activeRequest,
      errorMessage: errorMessage,
    );
  }
}

class AssistNotifier extends StateNotifier<AssistState> {
  final AssistUseCases _useCases;
  StreamSubscription<AssistanceRequest>? _requestSubscription;

  AssistNotifier(this._useCases) : super(const AssistState());

  @override
  void dispose() {
    _requestSubscription?.cancel();
    super.dispose();
  }

  Future<void> fetchProviders(MapCameraPosition location, {ServiceType? category, String? vehicleType}) async {
    state = state.copyWith(isLoading: true, activeCategory: category, errorMessage: null);
    try {
      final providers = await _useCases.getNearbyProviders(
        location: location,
        radiusMeters: 10000,
        categoryFilter: category,
        vehicleType: vehicleType,
      );
      state = state.copyWith(isLoading: false, providers: providers);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setCategoryFilter(MapCameraPosition location, ServiceType category, {String? vehicleType}) {
    final newCategory = state.activeCategory == category ? null : category;
    fetchProviders(location, category: newCategory, vehicleType: vehicleType);
  }

  void selectProvider(ServiceProvider provider) {
    state = state.copyWith(selectedProvider: provider);
  }

  void clearSelection() {
    state = state.clearSelectedProvider();
  }

  Future<void> requestAssistance(ServiceProvider provider, ServiceType serviceType) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final request = await _useCases.requestAssistance(
        providerId: provider.id,
        serviceType: serviceType,
      );
      
      state = state.copyWith(
        isLoading: false,
        activeRequest: request,
      );

      // Listen to future updates (WebSocket simulation)
      _requestSubscription?.cancel();
      _requestSubscription = _useCases.streamAssistanceStatus(request.id).listen((updatedRequest) {
        if (updatedRequest.status == AssistanceStatus.cancelled || updatedRequest.status == AssistanceStatus.completed) {
          state = state.copyWith(activeRequest: null);
          _requestSubscription?.cancel();
        } else {
          state = state.copyWith(activeRequest: updatedRequest);
        }
      });
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> cancelAssistance() async {
    if (state.activeRequest == null) return;
    
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _useCases.cancelAssistance(state.activeRequest!.id);
      _requestSubscription?.cancel();
      state = state.copyWith(isLoading: false, activeRequest: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final assistNotifierProvider = StateNotifierProvider<AssistNotifier, AssistState>((ref) {
  final useCases = ref.watch(assistUseCasesProvider);
  return AssistNotifier(useCases);
});
