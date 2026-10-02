import 'package:equatable/equatable.dart';

enum AlertState { none, sos, hazard, lowBattery, collision }

class DeviceTelemetry extends Equatable {
  final String deviceId;
  final String vehicleId;
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final bool ignition;
  final double battery;
  final DateTime lastSeen;
  final AlertState alertState;
  final bool isConnected;

  const DeviceTelemetry({
    required this.deviceId,
    required this.vehicleId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.ignition,
    required this.battery,
    required this.lastSeen,
    required this.alertState,
    this.isConnected = true,
  });

  DeviceTelemetry copyWith({
    String? deviceId,
    String? vehicleId,
    double? latitude,
    double? longitude,
    double? speed,
    double? heading,
    bool? ignition,
    double? battery,
    DateTime? lastSeen,
    AlertState? alertState,
    bool? isConnected,
  }) {
    return DeviceTelemetry(
      deviceId: deviceId ?? this.deviceId,
      vehicleId: vehicleId ?? this.vehicleId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      ignition: ignition ?? this.ignition,
      battery: battery ?? this.battery,
      lastSeen: lastSeen ?? this.lastSeen,
      alertState: alertState ?? this.alertState,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  factory DeviceTelemetry.fromJson(Map<String, dynamic> json) {
    return DeviceTelemetry(
      deviceId: json['device_id'],
      vehicleId: json['vehicle_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      speed: json['speed'].toDouble(),
      heading: json['heading'].toDouble(),
      ignition: json['ignition'],
      battery: json['battery'].toDouble(),
      lastSeen: DateTime.parse(json['last_seen']),
      alertState: AlertState.values.firstWhere(
          (e) => e.toString() == 'AlertState.${json['alert_state']}',
          orElse: () => AlertState.none),
      isConnected: json['is_connected'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'TELEMETRY',
      'device_id': deviceId,
      'vehicle_id': vehicleId,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'heading': heading,
      'ignition': ignition,
      'battery': battery,
      'last_seen': lastSeen.toIso8601String(),
      'alert_state': alertState.name,
      'is_connected': isConnected,
    };
  }

  @override
  List<Object?> get props => [
        deviceId,
        vehicleId,
        latitude,
        longitude,
        speed,
        heading,
        ignition,
        battery,
        lastSeen,
        alertState,
        isConnected,
      ];
}

class DeviceEvent extends Equatable {
  final String eventId;
  final String deviceId;
  final String eventType;
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  const DeviceEvent({
    required this.eventId,
    required this.deviceId,
    required this.eventType,
    required this.payload,
    required this.timestamp,
  });

  factory DeviceEvent.fromJson(Map<String, dynamic> json) {
    return DeviceEvent(
      eventId: json['event_id'],
      deviceId: json['device_id'],
      eventType: json['event_type'],
      payload: json['payload'] ?? {},
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'EVENT',
      'event_id': eventId,
      'device_id': deviceId,
      'event_type': eventType,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [eventId, deviceId, eventType, payload, timestamp];
}
