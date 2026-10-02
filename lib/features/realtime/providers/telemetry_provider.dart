import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/telemetry.dart';
import 'realtime_provider.dart';

final telemetryStreamProvider = StreamProvider<DeviceTelemetry>((ref) {
  final repository = ref.watch(realtimeRepositoryProvider);
  return repository.telemetryStream;
});

final eventStreamProvider = StreamProvider<DeviceEvent>((ref) {
  final repository = ref.watch(realtimeRepositoryProvider);
  return repository.eventStream;
});
