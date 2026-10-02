import 'dart:async';
import '../../domain/entities/assist/assist_entities.dart';
import '../../services/map/map_service.dart';

class MockAssistDataSource {
  final List<ServiceProvider> _mockProviders = [
    ServiceProvider(
      id: 'prov_1',
      name: 'Honda Rapid Rescue',
      latitude: 0.001,
      longitude: 0.001,
      distanceMeters: 800,
      supportedServices: const [ServiceType.roadsideAssistance, ServiceType.vehicleRepair],
      supportedVehicleTypes: const ['Car', 'Motorcycle', 'Scooter', 'Truck'],
      rating: 4.9,
      ratingCount: 1205,
      isOpen: true,
    ),
    ServiceProvider(
      id: 'prov_2',
      name: 'City Tyres & Towing',
      latitude: -0.002,
      longitude: 0.003,
      distanceMeters: 1500,
      supportedServices: const [ServiceType.tyre, ServiceType.roadsideAssistance],
      supportedVehicleTypes: const ['Car', 'Truck'],
      rating: 4.5,
      ratingCount: 340,
      isOpen: true,
    ),
    ServiceProvider(
      id: 'prov_3',
      name: 'Moto Battery Hub',
      latitude: 0.003,
      longitude: -0.001,
      distanceMeters: 2200,
      supportedServices: const [ServiceType.battery],
      supportedVehicleTypes: const ['Motorcycle', 'Scooter'],
      rating: 4.7,
      ratingCount: 89,
      isOpen: false,
    ),
  ];

  final Map<String, StreamController<AssistanceRequest>> _activeStreams = {};

  Future<List<ServiceProvider>> getNearbyProviders({
    required MapCameraPosition location,
    required double radiusMeters,
    ServiceType? categoryFilter,
    String? vehicleType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    var filtered = _mockProviders;

    if (categoryFilter != null) {
      filtered = filtered.where((p) => p.supportedServices.contains(categoryFilter)).toList();
    }
    if (vehicleType != null) {
      filtered = filtered.where((p) => p.supportedVehicleTypes.contains(vehicleType)).toList();
    }

    return filtered;
  }

  Future<AssistanceRequest> requestAssistance({
    required String providerId,
    required ServiceType serviceType,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final request = AssistanceRequest(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      providerId: providerId,
      serviceType: serviceType,
      status: AssistanceStatus.requested,
      timestamp: DateTime.now(),
    );

    // Setup mock websocket stream simulation
    final controller = StreamController<AssistanceRequest>.broadcast();
    _activeStreams[request.id] = controller;
    
    _simulateProviderUpdates(request, controller);

    return request;
  }

  void _simulateProviderUpdates(AssistanceRequest request, StreamController<AssistanceRequest> controller) async {
    controller.add(request);
    
    // Simulate accepted after 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (controller.isClosed) return;
    request = request.copyWith(status: AssistanceStatus.accepted);
    controller.add(request);

    // Simulate en route after 6 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (controller.isClosed) return;
    request = request.copyWith(status: AssistanceStatus.providerEnRoute);
    controller.add(request);
  }

  Future<void> cancelAssistance(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final controller = _activeStreams[requestId];
    if (controller != null && !controller.isClosed) {
      controller.add(AssistanceRequest(
        id: requestId,
        providerId: '',
        serviceType: ServiceType.roadsideAssistance, // Dummy fallback
        status: AssistanceStatus.cancelled,
        timestamp: DateTime.now(),
      ));
      controller.close();
      _activeStreams.remove(requestId);
    }
  }

  Stream<AssistanceRequest> streamAssistanceStatus(String requestId) {
    return _activeStreams[requestId]?.stream ?? const Stream.empty();
  }
}
