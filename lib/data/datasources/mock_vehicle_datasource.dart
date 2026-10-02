import '../../domain/entities/vehicle.dart';

class MockVehicleDataSource {
  Future<Vehicle> getVehicleDetails(String vehicleId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return const Vehicle(
      id: 'v_123',
      make: 'Honda',
      model: 'CR-V',
      year: 2024,
      type: VehicleType.car,
      registration: 'ABC-1234',
      fuelLevel: 0.75,
      batteryLevel: 1.0,
      deviceId: 'dev_1',
      healthStatus: VehicleHealth.good,
    );
  }

  Future<List<Vehicle>> getUserVehicles(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return [
      const Vehicle(
        id: 'v1',
        make: 'Honda',
        model: 'Civic',
        year: 2023,
        type: VehicleType.car,
        registration: 'ABC-1234',
        fuelLevel: 0.75,
        batteryLevel: 1.0,
        deviceId: 'dev_1',
        healthStatus: VehicleHealth.good,
      ),
      const Vehicle(
        id: 'v2',
        make: 'Honda',
        model: 'Activa',
        year: 2022,
        type: VehicleType.scooter,
        registration: 'XYZ-9876',
        fuelLevel: 0.40,
        batteryLevel: 0.9,
        deviceId: null,
        healthStatus: VehicleHealth.needsAttention,
      ),
    ];
  }
}
