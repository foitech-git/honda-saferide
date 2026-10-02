import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_service.dart';
import '../../core/theme/app_colors.dart';

class MockMapService implements MapService {
  @override
  Widget buildMapView({
    required MapCameraPosition initialCameraPosition,
    Set<MapMarker> markers = const {},
    Set<MapPolyline> polylines = const {},
    Function(MapCameraPosition)? onCameraMove,
  }) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(initialCameraPosition.latitude, initialCameraPosition.longitude),
        initialZoom: initialCameraPosition.zoom,
        onPositionChanged: (position, hasGesture) {
          if (onCameraMove != null) {
            onCameraMove(MapCameraPosition(
              latitude: position.center.latitude,
              longitude: position.center.longitude,
              zoom: position.zoom,
            ));
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.honda.saferide',
        ),
        if (polylines.isNotEmpty)
          PolylineLayer(
            polylines: polylines.map((p) => Polyline(
              points: p.points.map((pt) => LatLng(pt.latitude, pt.longitude)).toList(),
              color: p.color,
              strokeWidth: p.width.toDouble(),
            )).toList(),
          ),
        if (markers.isNotEmpty)
          MarkerLayer(
            markers: markers.map((m) => Marker(
              point: LatLng(m.latitude, m.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: m.onTap,
                child: m.customIcon ?? const Icon(Icons.location_on, color: AppColors.primaryRed, size: 40),
              ),
            )).toList(),
          ),
      ],
    );
  }
}
