import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/usecases/places_usecases.dart';
import '../../../core/utils/providers.dart';
import '../../../services/map/map_service.dart';

class PlacesState {
  final bool isLoading;
  final List<Place> places;
  final Place? selectedPlace;
  final PlaceType? activeFilter;
  final String? errorMessage;

  const PlacesState({
    this.isLoading = false,
    this.places = const [],
    this.selectedPlace,
    this.activeFilter,
    this.errorMessage,
  });

  PlacesState copyWith({
    bool? isLoading,
    List<Place>? places,
    Place? selectedPlace,
    PlaceType? activeFilter,
    String? errorMessage,
  }) {
    return PlacesState(
      isLoading: isLoading ?? this.isLoading,
      places: places ?? this.places,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: errorMessage,
    );
  }

  PlacesState clearSelectedPlace() {
    return PlacesState(
      isLoading: isLoading,
      places: places,
      selectedPlace: null,
      activeFilter: activeFilter,
      errorMessage: errorMessage,
    );
  }

  PlacesState clearFilter() {
    return PlacesState(
      isLoading: isLoading,
      places: places,
      selectedPlace: selectedPlace,
      activeFilter: null,
      errorMessage: errorMessage,
    );
  }
}

class PlacesNotifier extends StateNotifier<PlacesState> {
  final PlacesUseCases _useCases;

  PlacesNotifier(this._useCases) : super(const PlacesState());

  Future<void> fetchNearbyPlaces(MapCameraPosition location, {PlaceType? filter}) async {
    state = state.copyWith(isLoading: true, activeFilter: filter, errorMessage: null);
    try {
      final places = await _useCases.getNearbyPlacesByCategory(
        location: location,
        radiusMeters: 5000,
        typeFilter: filter,
      );
      state = state.copyWith(
        isLoading: false,
        places: places,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void selectPlace(Place place) {
    state = state.copyWith(selectedPlace: place);
  }

  void clearSelection() {
    state = state.clearSelectedPlace();
  }

  void applyFilter(MapCameraPosition location, PlaceType filter) {
    // If the same filter is clicked, we toggle it off
    if (state.activeFilter == filter) {
      fetchNearbyPlaces(location, filter: null);
    } else {
      fetchNearbyPlaces(location, filter: filter);
    }
  }
}

final placesNotifierProvider = StateNotifierProvider<PlacesNotifier, PlacesState>((ref) {
  final useCases = ref.watch(placesUseCasesProvider);
  return PlacesNotifier(useCases);
});
