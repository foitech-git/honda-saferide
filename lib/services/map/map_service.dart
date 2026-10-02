import 'package:flutter/material.dart';

class MapCameraPosition {
  final double latitude;
  final double longitude;
  final double zoom;

  const MapCameraPosition({
    required this.latitude,
    required this.longitude,
    required this.zoom,
  });
}

class MapMarker {
  final String id;
  final double latitude;
  final double longitude;
  final Widget? customIcon;
  final VoidCallback? onTap;

  const MapMarker({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.customIcon,
    this.onTap,
  });
}

class MapPolyline {
  final String id;
  final List<MapCameraPosition> points;
  final Color color;
  final int width;

  const MapPolyline({
    required this.id,
    required this.points,
    required this.color,
    this.width = 4,
  });
}

abstract class MapService {
  Widget buildMapView({
    required MapCameraPosition initialCameraPosition,
    Set<MapMarker> markers = const {},
    Set<MapPolyline> polylines = const {},
    Function(MapCameraPosition)? onCameraMove,
  });
}
