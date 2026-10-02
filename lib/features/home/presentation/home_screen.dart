import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/utils/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/data_display/app_data_display.dart';
import '../../../widgets/map/app_map_components.dart';
import '../../../widgets/feedback/app_feedback.dart';
import '../../../services/map/map_service.dart';
import '../../../domain/entities/route_option.dart';
import '../../routes/providers/route_provider.dart';
import '../../routes/presentation/route_bottom_sheet.dart';
import '../../realtime/providers/telemetry_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch mock routes on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(routeNotifierProvider.notifier).fetchRoutes(
        const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14),
        const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14),
      );
    });
  }

  void _handleRouteSelection(RouteType type) {
    final notifier = ref.read(routeNotifierProvider.notifier);
    notifier.selectRouteByType(type);
    
    final state = ref.read(routeNotifierProvider);
    if (state.selectedRoute != null) {
      AppBottomSheet.show(
        context: context,
        child: RouteBottomSheet(
          route: state.selectedRoute!,
          onStartRoute: () {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Starting ${state.selectedRoute!.name}...')),
            );
          },
          onCancel: () {
            notifier.clearSelection();
            context.pop();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(userVehiclesProvider('user_1'));
    final mapService = ref.watch(mapServiceProvider);
    final routeState = ref.watch(routeNotifierProvider);

    return SafeRideScaffold(
      drawer: AppSideDrawer(
        onVehicleTap: () {
          context.pop();
          context.push('/vehicle');
        },
        onServiceHistoryTap: () {
          context.pop();
          context.push('/service-history');
        },
        onPartsTap: () {
          context.pop();
          context.push('/parts-record');
        },
        onDocumentsTap: () {
          context.pop();
        },
        onEmergencyContactsTap: () {
          context.pop();
        },
        onSavedPlacesTap: () {
          context.pop();
        },
        onSettingsTap: () {
          context.pop();
        },
        onLogoutTap: () {
          ref.read(authNotifierProvider.notifier).logout();
        },
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) return; // already here
          if (index == 1) context.go('/places');
          if (index == 2) context.push('/sos');
          if (index == 3) context.go('/community');
          if (index == 4) context.go('/assist');
        },
      ),
      floatingActionButton: FloatingSOSButton(
        onTriggered: () {
          context.push('/sos');
        },
      ),
      body: Stack(
        children: [
          // MAP LAYER (Fills entire screen)
          Positioned.fill(
            child: Consumer(
              builder: (context, ref, child) {
                final telemetryAsync = ref.watch(telemetryStreamProvider);
                final mapService = ref.watch(mapServiceProvider);
                
                final double currentLat = telemetryAsync.value?.latitude ?? 35.6895; // Default Tokyo
                final double currentLng = telemetryAsync.value?.longitude ?? 139.6917;

                return mapService.buildMapView(
                  initialCameraPosition: MapCameraPosition(
                    latitude: currentLat,
                    longitude: currentLng,
                    zoom: 15.0,
                  ),
                  markers: {
                    MapMarker(
                      id: 'vehicle_location',
                      latitude: currentLat,
                      longitude: currentLng,
                      customIcon: const Icon(Icons.navigation, color: AppColors.routeMostUsed, size: 40),
                    )
                  }
                );
              }
            ),
          ),

          // TOP STATUS BAR LAYER
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: vehiclesAsync.when(
              data: (vehicles) {
                final vehicleName = vehicles.isNotEmpty 
                    ? '${vehicles.first.make} ${vehicles.first.model}' 
                    : 'No Vehicle';
                final isConnected = vehicles.isNotEmpty; // Mock logic

                return Container(
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
                      Builder(
                        builder: (context) => ProfileAvatar(
                          radius: 20,
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$vehicleName • ${isConnected ? "Connected" : "Disconnected"}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.primaryText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Vehicle status: ${isConnected ? "Good" : "Unknown"}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.success,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      NotificationButton(
                        badgeCount: 1,
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
              loading: () => const LoadingState(),
              error: (_, __) => const SizedBox(),
            ),
          ),

          // RIGHT SIDE MAP CONTROLS LAYER
          Positioned(
            right: 16,
            bottom: 140, // Keeps it comfortably above the bottom navigation / SOS
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (routeState.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16, right: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else ...[
                  _buildRouteFilterButton(
                    'Safe Route',
                    AppColors.routeSafe,
                    RouteType.safe,
                    routeState.selectedRoute?.type == RouteType.safe,
                  ),
                  const SizedBox(height: 8),
                  _buildRouteFilterButton(
                    'Well-Lit',
                    AppColors.routeWellLit,
                    RouteType.wellLit,
                    routeState.selectedRoute?.type == RouteType.wellLit,
                  ),
                  const SizedBox(height: 8),
                  _buildRouteFilterButton(
                    'Most Used',
                    AppColors.routeMostUsed,
                    RouteType.mostUsed,
                    routeState.selectedRoute?.type == RouteType.mostUsed,
                  ),
                ],
                const SizedBox(height: 24),
                MapControlButton(
                  icon: Icons.my_location,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteFilterButton(String label, Color color, RouteType type, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? Border.all(color: color, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _handleRouteSelection(type),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
