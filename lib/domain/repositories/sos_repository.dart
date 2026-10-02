import '../entities/sos/sos_event.dart';

abstract class SOSRepository {
  Future<SOSEvent> activateSOS(String userId);
  Future<void> cancelSOS(String eventId);
  Future<List<EmergencyContact>> getEmergencyContacts(String userId);
}
