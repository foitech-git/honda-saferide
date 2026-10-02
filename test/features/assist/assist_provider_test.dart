import 'package:flutter_test/flutter_test.dart';
import 'package:honda_saferide/domain/entities/assist/assist_entities.dart';
import 'package:honda_saferide/domain/repositories/assist_repository.dart';
import 'package:honda_saferide/domain/usecases/assist_usecases.dart';
import 'package:honda_saferide/features/assist/providers/assist_provider.dart';
import 'package:honda_saferide/services/map/map_service.dart';
import 'dart:async';

class FakeAssistRepository implements AssistRepository {
  final List<ServiceProvider> providers = [
    ServiceProvider(
      id: '1',
      name: 'Test Towing',
      latitude: 0,
      longitude: 0,
      distanceMeters: 500,
      supportedServices: const [ServiceType.roadsideAssistance],
      supportedVehicleTypes: const ['Car'],
      rating: 4.5,
      ratingCount: 10,
      isOpen: true,
    ),
    ServiceProvider(
      id: '2',
      name: 'Test Battery',
      latitude: 0,
      longitude: 0,
      distanceMeters: 1000,
      supportedServices: const [ServiceType.battery],
      supportedVehicleTypes: const ['Motorcycle'],
      rating: 4.0,
      ratingCount: 5,
      isOpen: true,
    ),
  ];

  @override
  Future<List<ServiceProvider>> getNearbyProviders({
    required MapCameraPosition location,
    required double radiusMeters,
    ServiceType? categoryFilter,
    String? vehicleType,
  }) async {
    var filtered = providers;
    if (categoryFilter != null) {
      filtered = filtered.where((p) => p.supportedServices.contains(categoryFilter)).toList();
    }
    return filtered;
  }

  @override
  Future<AssistanceRequest> requestAssistance({
    required String providerId,
    required ServiceType serviceType,
  }) async {
    return AssistanceRequest(
      id: 'req_1',
      providerId: providerId,
      serviceType: serviceType,
      status: AssistanceStatus.requested,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<void> cancelAssistance(String requestId) async {}

  @override
  Stream<AssistanceRequest> streamAssistanceStatus(String requestId) {
    return const Stream.empty();
  }
}

void main() {
  late AssistNotifier notifier;
  late FakeAssistRepository repository;

  setUp(() {
    repository = FakeAssistRepository();
    final useCases = AssistUseCases(repository);
    notifier = AssistNotifier(useCases);
  });

  test('initial state', () {
    expect(notifier.state.isLoading, false);
    expect(notifier.state.providers, isEmpty);
    expect(notifier.state.activeCategory, isNull);
  });

  test('fetchProviders loads providers', () async {
    await notifier.fetchProviders(const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14));
    expect(notifier.state.providers.length, 2);
  });

  test('setCategoryFilter applies filter correctly', () async {
    notifier.setCategoryFilter(
      const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14),
      ServiceType.battery,
    );
    await Future.delayed(Duration.zero);
    expect(notifier.state.activeCategory, ServiceType.battery);
    expect(notifier.state.providers.length, 1);
    expect(notifier.state.providers.first.name, 'Test Battery');
  });

  test('requestAssistance sets active request', () async {
    await notifier.fetchProviders(const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14));
    final provider = notifier.state.providers.first;
    
    await notifier.requestAssistance(provider, ServiceType.roadsideAssistance);
    expect(notifier.state.activeRequest, isNotNull);
    expect(notifier.state.activeRequest!.status, AssistanceStatus.requested);
  });

  test('cancelAssistance clears active request', () async {
    await notifier.fetchProviders(const MapCameraPosition(latitude: 0, longitude: 0, zoom: 14));
    final provider = notifier.state.providers.first;
    await notifier.requestAssistance(provider, ServiceType.roadsideAssistance);
    expect(notifier.state.activeRequest, isNotNull);

    await notifier.cancelAssistance();
    expect(notifier.state.activeRequest, isNull);
  });
}
