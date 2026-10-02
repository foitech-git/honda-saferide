import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/mock_vehicle_datasource.dart';
import '../../core/constants/environment.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final MockVehicleDataSource mockDataSource;

  VehicleRepositoryImpl({required this.mockDataSource});

  @override
  Future<Vehicle> getVehicleDetails(String vehicleId) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.getVehicleDetails(vehicleId);
    }
    // Future implementation for real API
    throw UnimplementedError('Real API not implemented yet');
  }

  @override
  Future<List<Vehicle>> getUserVehicles(String userId) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.getUserVehicles(userId);
    }
    // Future implementation for real API
    throw UnimplementedError('Real API not implemented yet');
  }
}
