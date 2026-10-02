import 'dart:async';
import '../entities/assist/assist_entities.dart';
import '../../services/map/map_service.dart';

abstract class AssistRepository {
  Future<List<ServiceProvider>> getNearbyProviders({
    required MapCameraPosition location,
    required double radiusMeters,
    ServiceType? categoryFilter,
    String? vehicleType,
  });

  Future<AssistanceRequest> requestAssistance({
    required String providerId,
    required ServiceType serviceType,
  });

  Future<void> cancelAssistance(String requestId);

  // Prepares for WebSocket integration
  Stream<AssistanceRequest> streamAssistanceStatus(String requestId);
}
