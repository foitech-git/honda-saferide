import 'dart:async';
import '../../domain/entities/assist/assist_entities.dart';
import '../../domain/repositories/assist_repository.dart';
import '../datasources/mock_assist_datasource.dart';
import '../../services/map/map_service.dart';
import '../../core/constants/environment.dart';

class AssistRepositoryImpl implements AssistRepository {
  final MockAssistDataSource mockDataSource;

  AssistRepositoryImpl({required this.mockDataSource});

  @override
  Future<List<ServiceProvider>> getNearbyProviders({
    required MapCameraPosition location,
    required double radiusMeters,
    ServiceType? categoryFilter,
    String? vehicleType,
  }) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.getNearbyProviders(
        location: location,
        radiusMeters: radiusMeters,
        categoryFilter: categoryFilter,
        vehicleType: vehicleType,
      );
    }
    throw UnimplementedError('Real Assist API not implemented yet');
  }

  @override
  Future<AssistanceRequest> requestAssistance({
    required String providerId,
    required ServiceType serviceType,
  }) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.requestAssistance(
        providerId: providerId,
        serviceType: serviceType,
      );
    }
    throw UnimplementedError('Real Assist API not implemented yet');
  }

  @override
  Future<void> cancelAssistance(String requestId) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.cancelAssistance(requestId);
    }
    throw UnimplementedError('Real Assist API not implemented yet');
  }

  @override
  Stream<AssistanceRequest> streamAssistanceStatus(String requestId) {
    if (Environment.current.useMockData) {
      return mockDataSource.streamAssistanceStatus(requestId);
    }
    throw UnimplementedError('Real Assist API not implemented yet');
  }
}
