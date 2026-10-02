import 'package:equatable/equatable.dart';
import '../../services/map/map_service.dart';

enum RouteType { normal, safe, wellLit, mostUsed }

class RouteMetrics extends Equatable {
  final double distanceMeters;
  final int durationSeconds;

  const RouteMetrics({
    required this.distanceMeters,
    required this.durationSeconds,
  });

  String get formattedDistance => '${(distanceMeters / 1000).toStringAsFixed(1)} km';
  String get formattedDuration => '${(durationSeconds / 60).round()} min';

  @override
  List<Object?> get props => [distanceMeters, durationSeconds];
}

class RouteSafetySignals extends Equatable {
  final String roadConditions;
  final int incidents;
  final String lighting;
  final double userFeedbackScore;

  const RouteSafetySignals({
    required this.roadConditions,
    required this.incidents,
    required this.lighting,
    required this.userFeedbackScore,
  });

  @override
  List<Object?> get props => [roadConditions, incidents, lighting, userFeedbackScore];
}

class RouteOption extends Equatable {
  final String id;
  final String name;
  final RouteType type;
  final RouteMetrics metrics;
  final RouteSafetySignals signals;
  final List<MapCameraPosition> geometry; // Abstract representation of coordinates

  const RouteOption({
    required this.id,
    required this.name,
    required this.type,
    required this.metrics,
    required this.signals,
    required this.geometry,
  });

  @override
  List<Object?> get props => [id, name, type, metrics, signals, geometry];
}
