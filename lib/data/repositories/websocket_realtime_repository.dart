import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../domain/entities/telemetry.dart';
import '../../domain/repositories/realtime_repository.dart';

class WebSocketRealtimeRepository implements RealtimeRepository {
  WebSocketChannel? _channel;
  final _telemetryController = StreamController<DeviceTelemetry>.broadcast();
  final _eventController = StreamController<DeviceEvent>.broadcast();

  @override
  Stream<DeviceTelemetry> get telemetryStream => _telemetryController.stream;

  @override
  Stream<DeviceEvent> get eventStream => _eventController.stream;

  @override
  Future<void> connect(String url) async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            if (data['type'] == 'TELEMETRY') {
              _telemetryController.add(DeviceTelemetry.fromJson(data));
            } else if (data['type'] == 'EVENT') {
              _eventController.add(DeviceEvent.fromJson(data));
            }
          } catch (e) {
            // Ignore parse errors for unknown formats
          }
        },
        onError: (error) {
          // Handle connection error silently or log
        },
        onDone: () {
          // Handle disconnect
        },
      );
    } catch (e) {
      // Failed to connect
    }
  }

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }

  @override
  Future<void> sendTelemetry(DeviceTelemetry telemetry) async {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(telemetry.toJson()));
    }
  }

  @override
  Future<void> sendEvent(DeviceEvent event) async {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(event.toJson()));
    }
  }

  void dispose() {
    _telemetryController.close();
    _eventController.close();
    disconnect();
  }
}
