import '../../domain/entities/history/history_entities.dart';

class MockServiceDataSource {
  Future<List<ServiceRecord>> getServiceHistory(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      ServiceRecord(
        id: 'srv_1',
        vehicleId: vehicleId,
        title: 'Periodic Service',
        date: DateTime(2026, 9, 12),
        status: ServiceStatus.completed,
        providerName: 'Honda Downtown Service',
        mileage: 24500,
      ),
      ServiceRecord(
        id: 'srv_2',
        vehicleId: vehicleId,
        title: 'Brake Inspection',
        date: DateTime(2026, 8, 3),
        status: ServiceStatus.completed,
        providerName: 'Honda Downtown Service',
        mileage: 22100,
      ),
      ServiceRecord(
        id: 'srv_3',
        vehicleId: vehicleId,
        title: 'Engine Oil Replacement',
        date: DateTime(2026, 6, 17),
        status: ServiceStatus.completed,
        providerName: 'Quick Lube Express',
        mileage: 18000,
      ),
    ];
  }
}

class MockPartsDataSource {
  Future<List<PartRecord>> getPartsRecord(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      PartRecord(
        id: 'prt_1',
        vehicleId: vehicleId,
        partName: 'Brake Pads',
        manufacturer: 'Honda Genuine Parts',
        installationDate: DateTime(2026, 8, 3),
        mileageAtInstall: 22100,
        serviceProvider: 'Honda Downtown Service',
      ),
      PartRecord(
        id: 'prt_2',
        vehicleId: vehicleId,
        partName: 'Battery',
        manufacturer: 'Yuasa',
        installationDate: DateTime(2025, 11, 10),
        mileageAtInstall: 12000,
        serviceProvider: 'Moto Battery Hub',
      ),
      PartRecord(
        id: 'prt_3',
        vehicleId: vehicleId,
        partName: 'Tyres',
        manufacturer: 'Michelin Pilot Street',
        installationDate: DateTime(2025, 5, 20),
        mileageAtInstall: 5000,
        serviceProvider: 'City Tyres & Towing',
      ),
      PartRecord(
        id: 'prt_4',
        vehicleId: vehicleId,
        partName: 'Air Filter',
        manufacturer: 'Honda Genuine Parts',
        installationDate: DateTime(2026, 9, 12),
        mileageAtInstall: 24500,
        serviceProvider: 'Honda Downtown Service',
      ),
    ];
  }
}
