import 'package:flutter_test/flutter_test.dart';
import 'package:honda_saferide/domain/entities/history/history_entities.dart';

void main() {
  group('History Entities', () {
    test('ServiceRecord props match', () {
      final date = DateTime.now();
      final record1 = ServiceRecord(
        id: '1',
        vehicleId: 'v1',
        title: 'Oil Change',
        date: date,
        status: ServiceStatus.completed,
      );
      final record2 = ServiceRecord(
        id: '1',
        vehicleId: 'v1',
        title: 'Oil Change',
        date: date,
        status: ServiceStatus.completed,
      );

      expect(record1, equals(record2));
    });

    test('PartRecord supports optional replacementDate', () {
      final date = DateTime.now();
      final record = PartRecord(
        id: '1',
        vehicleId: 'v1',
        partName: 'Battery',
        manufacturer: 'Honda',
        installationDate: date,
        mileageAtInstall: 10000,
        serviceProvider: 'Dealer',
      );

      expect(record.replacementDate, isNull);
    });
  });
}
