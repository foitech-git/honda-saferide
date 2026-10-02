import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/mock_vehicle_datasource.dart';
import '../../data/datasources/mock_auth_datasource.dart';
import '../../data/datasources/mock_route_datasource.dart';
import '../../data/datasources/mock_places_datasource.dart';
import '../../data/datasources/mock_sos_datasource.dart';
import '../../data/datasources/mock_community_datasource.dart';
import '../../data/datasources/mock_assist_datasource.dart';
import '../../data/datasources/mock_history_datasource.dart';
import '../../data/repositories/vehicle_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/route_repository_impl.dart';
import '../../data/repositories/places_repository_impl.dart';
import '../../data/repositories/sos_repository_impl.dart';
import '../../data/repositories/community_repository_impl.dart';
import '../../data/repositories/assist_repository_impl.dart';
import '../../data/repositories/history_repositories_impl.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/route_repository.dart';
import '../../domain/repositories/places_repository.dart';
import '../../domain/repositories/sos_repository.dart';
import '../../domain/repositories/community_repository.dart';
import '../../domain/repositories/assist_repository.dart';
import '../../domain/repositories/history_repositories.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/history/history_entities.dart';
import '../../domain/usecases/route_recommendation_usecase.dart';
import '../../domain/usecases/places_usecases.dart';
import '../../domain/usecases/sos_usecases.dart';
import '../../domain/usecases/community_usecases.dart';
import '../../domain/usecases/assist_usecases.dart';
import '../../services/map/map_service.dart';
import '../../services/map/mock_map_service.dart';

// Services
final mapServiceProvider = Provider<MapService>((ref) {
  return MockMapService();
});

// Data Sources
final mockVehicleDataSourceProvider = Provider<MockVehicleDataSource>((ref) {
  return MockVehicleDataSource();
});

final mockAuthDataSourceProvider = Provider<MockAuthDataSource>((ref) {
  return MockAuthDataSource();
});

final mockRouteDataSourceProvider = Provider<MockRouteDataSource>((ref) {
  return MockRouteDataSource();
});

final mockPlacesDataSourceProvider = Provider<MockPlacesDataSource>((ref) {
  return MockPlacesDataSource();
});

final mockSOSDataSourceProvider = Provider<MockSOSDataSource>((ref) {
  return MockSOSDataSource();
});

final mockCommunityDataSourceProvider = Provider<MockCommunityDataSource>((ref) {
  return MockCommunityDataSource();
});

final mockAssistDataSourceProvider = Provider<MockAssistDataSource>((ref) {
  return MockAssistDataSource();
});

final mockServiceDataSourceProvider = Provider<MockServiceDataSource>((ref) {
  return MockServiceDataSource();
});

final mockPartsDataSourceProvider = Provider<MockPartsDataSource>((ref) {
  return MockPartsDataSource();
});

// Repositories
final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final mockDataSource = ref.watch(mockVehicleDataSourceProvider);
  return VehicleRepositoryImpl(mockDataSource: mockDataSource);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final mockDataSource = ref.watch(mockAuthDataSourceProvider);
  return AuthRepositoryImpl(mockDataSource: mockDataSource);
});

final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  final mockDataSource = ref.watch(mockRouteDataSourceProvider);
  return RouteRepositoryImpl(mockDataSource: mockDataSource);
});

final placesRepositoryProvider = Provider<PlacesRepository>((ref) {
  final mockDataSource = ref.watch(mockPlacesDataSourceProvider);
  return PlacesRepositoryImpl(mockDataSource: mockDataSource);
});

final sosRepositoryProvider = Provider<SOSRepository>((ref) {
  final mockDataSource = ref.watch(mockSOSDataSourceProvider);
  return SOSRepositoryImpl(mockDataSource: mockDataSource);
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final mockDataSource = ref.watch(mockCommunityDataSourceProvider);
  return CommunityRepositoryImpl(mockDataSource: mockDataSource);
});

final assistRepositoryProvider = Provider<AssistRepository>((ref) {
  final mockDataSource = ref.watch(mockAssistDataSourceProvider);
  return AssistRepositoryImpl(mockDataSource: mockDataSource);
});

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  final mockDataSource = ref.watch(mockServiceDataSourceProvider);
  return ServiceRepositoryImpl(mockDataSource: mockDataSource);
});

final partsRepositoryProvider = Provider<PartsRepository>((ref) {
  final mockDataSource = ref.watch(mockPartsDataSourceProvider);
  return PartsRepositoryImpl(mockDataSource: mockDataSource);
});

// Use Cases / View Models
final routeRecommendationUseCaseProvider = Provider<RouteRecommendationUseCase>((ref) {
  final repository = ref.watch(routeRepositoryProvider);
  return RouteRecommendationUseCase(repository);
});

final placesUseCasesProvider = Provider<PlacesUseCases>((ref) {
  final repository = ref.watch(placesRepositoryProvider);
  return PlacesUseCases(repository);
});

final sosUseCasesProvider = Provider<SOSUseCases>((ref) {
  final repository = ref.watch(sosRepositoryProvider);
  return SOSUseCases(repository);
});

final communityUseCasesProvider = Provider<CommunityUseCases>((ref) {
  final repository = ref.watch(communityRepositoryProvider);
  return CommunityUseCases(repository);
});

final assistUseCasesProvider = Provider<AssistUseCases>((ref) {
  final repository = ref.watch(assistRepositoryProvider);
  return AssistUseCases(repository);
});

final userVehiclesProvider = FutureProvider.family<List<Vehicle>, String>((ref, userId) async {
  final repository = ref.watch(vehicleRepositoryProvider);
  return repository.getUserVehicles(userId);
});

final serviceHistoryProvider = FutureProvider.family<List<ServiceRecord>, String>((ref, vehicleId) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getServiceHistory(vehicleId);
});

final partsRecordProvider = FutureProvider.family<List<PartRecord>, String>((ref, vehicleId) async {
  final repository = ref.watch(partsRepositoryProvider);
  return repository.getPartsRecord(vehicleId);
});
