import '../../domain/entities/history/history_entities.dart';
import '../../domain/repositories/history_repositories.dart';
import '../datasources/mock_history_datasource.dart';
import '../../core/constants/environment.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final MockServiceDataSource mockDataSource;

  ServiceRepositoryImpl({required this.mockDataSource});

  @override
  Future<List<ServiceRecord>> getServiceHistory(String vehicleId) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.getServiceHistory(vehicleId);
    }
    throw UnimplementedError('Real Service API not implemented yet');
  }
}

class PartsRepositoryImpl implements PartsRepository {
  final MockPartsDataSource mockDataSource;

  PartsRepositoryImpl({required this.mockDataSource});

  @override
  Future<List<PartRecord>> getPartsRecord(String vehicleId) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.getPartsRecord(vehicleId);
    }
    throw UnimplementedError('Real Parts API not implemented yet');
  }
}
