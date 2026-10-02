import '../entities/sos/sos_event.dart';
import '../repositories/sos_repository.dart';

class SOSUseCases {
  final SOSRepository repository;

  SOSUseCases(this.repository);

  Future<SOSEvent> activateSOS(String userId) async {
    return await repository.activateSOS(userId);
  }

  Future<void> cancelSOS(String eventId) async {
    await repository.cancelSOS(eventId);
  }

  Future<List<EmergencyContact>> getEmergencyContacts(String userId) async {
    return await repository.getEmergencyContacts(userId);
  }
}
