import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/realtime_repository.dart';
import '../../../data/repositories/websocket_realtime_repository.dart';

final realtimeRepositoryProvider = Provider<RealtimeRepository>((ref) {
  final repository = WebSocketRealtimeRepository();
  ref.onDispose(() => (repository as WebSocketRealtimeRepository).dispose());
  return repository;
});
