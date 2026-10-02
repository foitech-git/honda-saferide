import '../entities/telemetry.dart';

abstract class RealtimeRepository {
  Stream<DeviceTelemetry> get telemetryStream;
  Stream<DeviceEvent> get eventStream;
  
  Future<void> connect(String url);
  Future<void> disconnect();
  
  Future<void> sendTelemetry(DeviceTelemetry telemetry);
  Future<void> sendEvent(DeviceEvent event);
}
