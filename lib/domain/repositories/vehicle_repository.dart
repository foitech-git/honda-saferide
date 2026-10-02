import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Future<Vehicle> getVehicleDetails(String vehicleId);
  Future<List<Vehicle>> getUserVehicles(String userId);
}
