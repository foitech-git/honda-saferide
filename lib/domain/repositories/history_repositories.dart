import '../entities/history/history_entities.dart';

abstract class ServiceRepository {
  Future<List<ServiceRecord>> getServiceHistory(String vehicleId);
}

abstract class PartsRepository {
  Future<List<PartRecord>> getPartsRecord(String vehicleId);
}
