import 'package:equatable/equatable.dart';

enum DeviceStatus { disconnected, connecting, connected, error }

class Device extends Equatable {
  final String id;
  final String deviceId; // e.g., HSR-DEV-000001
  final DeviceStatus status;

  const Device({
    required this.id,
    required this.deviceId,
    this.status = DeviceStatus.disconnected,
  });

  @override
  List<Object?> get props => [id, deviceId, status];
}
