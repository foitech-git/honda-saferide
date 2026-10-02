import 'package:flutter_test/flutter_test.dart';
import 'package:honda_saferide/domain/entities/vehicle.dart';

void main() {
  group('Vehicle Entity', () {
    test('displayName formats correctly', () {
      const vehicle = Vehicle(
        id: '1',
        make: 'Honda',
        model: 'Civic',
        year: 2023,
        type: VehicleType.car,
        fuelLevel: 1.0,
        batteryLevel: 1.0,
      );

      expect(vehicle.displayName, 'Honda Civic');
    });

    test('supports optional deviceId and defaults to good health', () {
      const vehicle = Vehicle(
        id: '1',
        make: 'Honda',
        model: 'Activa',
        year: 2022,
        type: VehicleType.scooter,
        fuelLevel: 0.5,
        batteryLevel: 0.9,
      );

      expect(vehicle.deviceId, isNull);
      expect(vehicle.healthStatus, VehicleHealth.good);
    });
  });
}
