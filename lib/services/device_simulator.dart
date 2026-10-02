import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/telemetry.dart';
import '../domain/repositories/realtime_repository.dart';
import '../features/realtime/providers/realtime_provider.dart';

final deviceSimulatorProvider = Provider<DeviceSimulator>((ref) {
  final repository = ref.watch(realtimeRepositoryProvider);
  return DeviceSimulator(repository);
});

class DeviceSimulator {
  final RealtimeRepository _repository;
  Timer? _movementTimer;
  
  // Simulated state
  bool isConnected = false;
  bool ignition = false;
  double speed = 0.0;
  double battery = 1.0;
  AlertState alertState = AlertState.none;
  
  // Base location (e.g. San Francisco)
  double latitude = 37.7749;
  double longitude = -122.4194;
  
  DeviceSimulator(this._repository);

  Future<void> connect() async {
    // In dev, assuming Go backend is on localhost:8080
    await _repository.connect('ws://localhost:8080/ws');
    isConnected = true;
    _sendUpdate();
  }

  Future<void> disconnect() async {
    await _repository.disconnect();
    isConnected = false;
    stopMovement();
  }

  void startMovement() {
    ignition = true;
    if (speed == 0) speed = 30.0; // km/h
    
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Very basic simulated movement (roughly north-east)
      latitude += (speed * 0.00001);
      longitude += (speed * 0.00001);
      battery -= 0.001; // battery drain
      if (battery < 0) battery = 0;
      
      _sendUpdate();
    });
  }

  void stopMovement() {
    ignition = false;
    speed = 0.0;
    _movementTimer?.cancel();
    _sendUpdate();
  }

  void setSpeed(double newSpeed) {
    speed = newSpeed;
    if (ignition && _movementTimer == null) {
      startMovement();
    } else {
      _sendUpdate();
    }
  }

  void setBattery(double newBattery) {
    battery = newBattery;
    _sendUpdate();
  }

  void triggerAlert(AlertState alert) {
    alertState = alert;
    _sendUpdate();
    
    _repository.sendEvent(DeviceEvent(
      eventId: 'evt_${DateTime.now().millisecondsSinceEpoch}',
      deviceId: 'HSR-DEV-000001',
      eventType: alert.name.toUpperCase(),
      payload: {'message': 'Simulator triggered alert'},
      timestamp: DateTime.now(),
    ));
  }

  void _sendUpdate() {
    if (!isConnected) return;
    
    final telemetry = DeviceTelemetry(
      deviceId: 'HSR-DEV-000001',
      vehicleId: 'veh_mock_123',
      latitude: latitude,
      longitude: longitude,
      speed: speed,
      heading: 45.0, // Fixed heading for simplicity
      ignition: ignition,
      battery: battery,
      lastSeen: DateTime.now(),
      alertState: alertState,
      isConnected: isConnected,
    );
    
    _repository.sendTelemetry(telemetry);
  }
}
