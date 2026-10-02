import 'dart:async';
import '../entities/assist/assist_entities.dart';
import '../repositories/assist_repository.dart';
import '../../services/map/map_service.dart';

class AssistUseCases {
  final AssistRepository repository;

  AssistUseCases(this.repository);

  Future<List<ServiceProvider>> getNearbyProviders({
    required MapCameraPosition location,
    required double radiusMeters,
    ServiceType? categoryFilter,
    String? vehicleType,
  }) async {
    return await repository.getNearbyProviders(
      location: location,
      radiusMeters: radiusMeters,
      categoryFilter: categoryFilter,
      vehicleType: vehicleType,
    );
  }

  Future<AssistanceRequest> requestAssistance({
    required String providerId,
    required ServiceType serviceType,
  }) async {
    return await repository.requestAssistance(
      providerId: providerId,
      serviceType: serviceType,
    );
  }

  Future<void> cancelAssistance(String requestId) async {
    await repository.cancelAssistance(requestId);
  }

  Stream<AssistanceRequest> streamAssistanceStatus(String requestId) {
    return repository.streamAssistanceStatus(requestId);
  }
}
