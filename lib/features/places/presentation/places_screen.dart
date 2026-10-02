import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/map/app_map_components.dart';
import '../../../services/map/map_service.dart';
import '../../../domain/entities/place.dart';
import '../providers/places_provider.dart';
import 'place_bottom_sheet.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  final MapCameraPosition _currentLocation = const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(placesNotifierProvider.notifier).fetchNearbyPlaces(_currentLocation);
    });
  }

  void _handleCategoryTap(PlaceType type) {
    ref.read(placesNotifierProvider.notifier).applyFilter(_currentLocation, type);
  }

  void _handlePlaceSelection(Place place) {
    final notifier = ref.read(placesNotifierProvider.notifier);
    notifier.selectPlace(place);
    
    AppBottomSheet.show(
      context: context,
      child: PlaceBottomSheet(
        place: place,
        onNavigate: () {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigating to ${place.name}...')),
          );
        },
        onCancel: () {
          notifier.clearSelection();
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapService = ref.watch(mapServiceProvider);
    final placesState = ref.watch(placesNotifierProvider);

    // Mock markers from places
    final markers = placesState.places.map((p) {
      return MapMarker(
        id: p.id,
        latitude: p.latitude,
        longitude: p.longitude,
        onTap: () => _handlePlaceSelection(p),
      );
    }).toSet();

    return SafeRideScaffold(
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 1, // Places is index 1
        onTap: (index) {
          if (index == 0) context.go('/');
          if (index == 1) return; // already here
          if (index == 2) context.push('/sos');
          if (index == 3) context.go('/community');
          if (index == 4) context.go('/assist');
        },
      ),
      body: Stack(
        children: [
          // MAP LAYER
          Positioned.fill(
            child: mapService.buildMapView(
              initialCameraPosition: _currentLocation,
              markers: markers,
            ),
          ),

          // TOP UI LAYER
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Nearby Places',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      if (placesState.isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Category Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip(
                        'Safe Parking',
                        Icons.local_parking,
                        PlaceType.safeParking,
                        placesState.activeFilter == PlaceType.safeParking,
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryChip(
                        'EV Charging',
                        Icons.electric_car,
                        PlaceType.evCharging,
                        placesState.activeFilter == PlaceType.evCharging,
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryChip(
                        'Fuel',
                        Icons.local_gas_station,
                        PlaceType.fuel,
                        placesState.activeFilter == PlaceType.fuel,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // MAP CONTROLS
          Positioned(
            right: 16,
            bottom: 32,
            child: MapControlButton(
              icon: Icons.my_location,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, PlaceType type, bool isSelected) {
    return InkWell(
      onTap: () => _handleCategoryTap(type),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.border,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.primaryText,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
                color: isSelected ? Colors.white : AppColors.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
