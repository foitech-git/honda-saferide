import '../../domain/entities/sos/sos_event.dart';

class MockSOSDataSource {
  Future<SOSEvent> activateSOS(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Network delay

    return SOSEvent(
      id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
      activatedAt: DateTime.now(),
      status: SOSStatus.active,
      isLocationShared: true,
      isEmergencyServicesNotified: false,
      vehicleStatus: 'Stationary (Last known)',
    );
  }

  Future<void> cancelSOS(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulates cancelling the event on the backend
  }

  Future<List<EmergencyContact>> getEmergencyContacts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      EmergencyContact(
        id: 'c1',
        name: 'Jane Doe',
        phone: '+1 555-0100',
        relation: 'Spouse',
      ),
      EmergencyContact(
        id: 'c2',
        name: 'John Smith',
        phone: '+1 555-0200',
        relation: 'Brother',
      ),
    ];
  }
}
