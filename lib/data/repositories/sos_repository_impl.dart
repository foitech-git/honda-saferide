import '../../domain/entities/sos/sos_event.dart';
import '../../domain/repositories/sos_repository.dart';
import '../datasources/mock_sos_datasource.dart';
import '../../core/constants/environment.dart';

class SOSRepositoryImpl implements SOSRepository {
  final MockSOSDataSource mockDataSource;

  SOSRepositoryImpl({required this.mockDataSource});

  @override
  Future<SOSEvent> activateSOS(String userId) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.activateSOS(userId);
    }
    throw UnimplementedError('Real SOS API not implemented yet');
  }

  @override
  Future<void> cancelSOS(String eventId) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.cancelSOS(eventId);
    }
    throw UnimplementedError('Real SOS API not implemented yet');
  }

  @override
  Future<List<EmergencyContact>> getEmergencyContacts(String userId) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.getEmergencyContacts(userId);
    }
    throw UnimplementedError('Real SOS API not implemented yet');
  }
}
