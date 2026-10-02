import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/map/app_map_components.dart';
import '../../../services/map/map_service.dart';
import '../../../domain/entities/community/community_report.dart';
import '../providers/community_provider.dart';
import 'report_bottom_sheet.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final MapCameraPosition _currentLocation = const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(communityNotifierProvider.notifier).fetchReports(_currentLocation);
    });
  }

  void _handleFilterTap(CommunityFilter filter) {
    ref.read(communityNotifierProvider.notifier).setFilter(_currentLocation, filter);
  }

  void _showReportBottomSheet() {
    AppBottomSheet.show(
      context: context,
      child: ReportBottomSheet(
        onSubmit: (type, description) async {
          return await ref.read(communityNotifierProvider.notifier).submitReport(
                type: type,
                latitude: _currentLocation.latitude,
                longitude: _currentLocation.longitude,
                description: description,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapService = ref.watch(mapServiceProvider);
    final communityState = ref.watch(communityNotifierProvider);

    // Create markers from reports
    final markers = communityState.reports.map((r) {
      return MapMarker(
        id: r.id,
        latitude: r.latitude,
        longitude: r.longitude,
        onTap: () {
          // Display simple info snippet or toast for now
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${r.typeName} reported by ${r.source}')),
          );
        },
      );
    }).toSet();

    return SafeRideScaffold(
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 3, // Community is index 3
        onTap: (index) {
          if (index == 0) context.go('/');
          if (index == 1) context.go('/places');
          if (index == 2) context.push('/sos');
          if (index == 3) return; // already here
          if (index == 4) context.go('/assist');
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showReportBottomSheet,
        backgroundColor: AppColors.warning,
        icon: const Icon(Icons.add_alert, color: Colors.white),
        label: const Text('Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                          'Community Reports',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      if (communityState.isLoading)
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
                      _buildFilterChip('Hazards', Icons.warning_amber, CommunityFilter.hazards, communityState.activeFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('Accidents', Icons.car_crash, CommunityFilter.accidents, communityState.activeFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('Traffic', Icons.traffic, CommunityFilter.traffic, communityState.activeFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('Safety', Icons.security, CommunityFilter.safety, communityState.activeFilter),
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

  Widget _buildFilterChip(String label, IconData icon, CommunityFilter filter, CommunityFilter activeFilter) {
    final isSelected = filter == activeFilter;
    return InkWell(
      onTap: () => _handleFilterTap(filter),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryText : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryText : AppColors.border,
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
