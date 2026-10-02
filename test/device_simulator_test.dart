import 'package:flutter_test/flutter_test.dart';
import 'package:honda_saferide/services/device_simulator.dart';
import 'package:honda_saferide/domain/entities/telemetry.dart';
import 'package:honda_saferide/domain/repositories/realtime_repository.dart';
import 'dart:async';

class MockRealtimeRepository implements RealtimeRepository {
  final _telemetryController = StreamController<DeviceTelemetry>.broadcast();
  final _eventController = StreamController<DeviceEvent>.broadcast();

  final List<DeviceTelemetry> sentTelemetry = [];
  final List<DeviceEvent> sentEvents = [];
  bool isConnected = false;

  @override
  Stream<DeviceTelemetry> get telemetryStream => _telemetryController.stream;

  @override
  Stream<DeviceEvent> get eventStream => _eventController.stream;

  @override
  Future<void> connect(String url) async {
    isConnected = true;
  }

  @override
  Future<void> disconnect() async {
    isConnected = false;
  }

  @override
  Future<void> sendTelemetry(DeviceTelemetry telemetry) async {
    sentTelemetry.add(telemetry);
    _telemetryController.add(telemetry);
  }

  @override
  Future<void> sendEvent(DeviceEvent event) async {
    sentEvents.add(event);
    _eventController.add(event);
  }
}

void main() {
  group('DeviceSimulator', () {
    late MockRealtimeRepository repository;
    late DeviceSimulator simulator;

    setUp(() {
      repository = MockRealtimeRepository();
      simulator = DeviceSimulator(repository);
    });

    test('should connect and send initial telemetry', () async {
      await simulator.connect();
      expect(repository.isConnected, true);
      expect(simulator.isConnected, true);
      expect(repository.sentTelemetry.isNotEmpty, true);
    });

    test('should start movement and update location', () async {
      await simulator.connect();
      simulator.startMovement();
      
      expect(simulator.ignition, true);
      expect(simulator.speed, 30.0);
      
      // Wait for 1 tick of the timer
      await Future.delayed(const Duration(seconds: 2));
      
      expect(repository.sentTelemetry.length, greaterThan(1));
      
      final latest = repository.sentTelemetry.last;
      expect(latest.speed, 30.0);
      expect(latest.ignition, true);
      
      simulator.stopMovement();
    });

    test('should trigger SOS event', () async {
      await simulator.connect();
      simulator.triggerAlert(AlertState.sos);
      
      expect(repository.sentEvents.isNotEmpty, true);
      final event = repository.sentEvents.last;
      expect(event.eventType, 'SOS');
      expect(simulator.alertState, AlertState.sos);
      
      final telemetry = repository.sentTelemetry.last;
      expect(telemetry.alertState, AlertState.sos);
    });
  });
}
