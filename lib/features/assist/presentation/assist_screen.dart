import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/map/app_map_components.dart';
import '../../../services/map/map_service.dart';
import '../../../domain/entities/assist/assist_entities.dart';
import '../providers/assist_provider.dart';
import 'provider_bottom_sheet.dart';
import 'active_assistance_overlay.dart';

class AssistScreen extends ConsumerStatefulWidget {
  const AssistScreen({super.key});

  @override
  ConsumerState<AssistScreen> createState() => _AssistScreenState();
}

class _AssistScreenState extends ConsumerState<AssistScreen> {
  final MapCameraPosition _currentLocation = const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(assistNotifierProvider.notifier).fetchProviders(_currentLocation);
    });
  }

  void _handleCategoryTap(ServiceType category) {
    ref.read(assistNotifierProvider.notifier).setCategoryFilter(_currentLocation, category);
  }

  void _handleProviderSelection(ServiceProvider provider) {
    ref.read(assistNotifierProvider.notifier).selectProvider(provider);
    
    AppBottomSheet.show(
      context: context,
      child: ProviderBottomSheet(provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapService = ref.watch(mapServiceProvider);
    final assistState = ref.watch(assistNotifierProvider);

    // Create markers from providers
    final markers = assistState.providers.map((p) {
      return MapMarker(
        id: p.id,
        latitude: p.latitude,
        longitude: p.longitude,
        onTap: () => _handleProviderSelection(p),
      );
    }).toSet();

    return SafeRideScaffold(
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 4, // Assist is index 4
        onTap: (index) {
          if (index == 0) context.go('/');
          if (index == 1) context.go('/places');
          if (index == 2) context.push('/sos');
          if (index == 3) context.go('/community');
          // index 4 is here
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

          // TOP UI LAYER (Filters)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                          'Roadside Assistance',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      if (assistState.isLoading && assistState.activeRequest == null)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Roadside Assist', Icons.handyman, ServiceType.roadsideAssistance, assistState.activeCategory),
                      const SizedBox(width: 8),
                      _buildFilterChip('Vehicle Repair', Icons.build, ServiceType.vehicleRepair, assistState.activeCategory),
                      const SizedBox(width: 8),
                      _buildFilterChip('Tyre', Icons.tire_repair, ServiceType.tyre, assistState.activeCategory),
                      const SizedBox(width: 8),
                      _buildFilterChip('Battery', Icons.battery_charging_full, ServiceType.battery, assistState.activeCategory),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // ACTIVE ASSISTANCE OVERLAY
          const ActiveAssistanceOverlay(),

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

  Widget _buildFilterChip(String label, IconData icon, ServiceType filter, ServiceType? activeFilter) {
    final isSelected = filter == activeFilter;
    return InkWell(
      onTap: () => _handleCategoryTap(filter),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.routeMostUsed : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.routeMostUsed : AppColors.border,
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
