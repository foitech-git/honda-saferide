import 'package:flutter_test/flutter_test.dart';
import 'package:honda_saferide/domain/entities/sos/sos_event.dart';
import 'package:honda_saferide/domain/repositories/sos_repository.dart';
import 'package:honda_saferide/domain/usecases/sos_usecases.dart';
import 'package:honda_saferide/features/sos/providers/sos_provider.dart';

class FakeSOSRepository implements SOSRepository {
  SOSEvent? currentEvent;

  @override
  Future<SOSEvent> activateSOS(String userId) async {
    currentEvent = SOSEvent(
      id: 'test_event',
      activatedAt: DateTime.now(),
      status: SOSStatus.active,
      isLocationShared: true,
      isEmergencyServicesNotified: false,
      vehicleStatus: 'Stationary',
    );
    return currentEvent!;
  }

  @override
  Future<void> cancelSOS(String eventId) async {
    if (currentEvent?.id == eventId) {
      currentEvent = null;
    }
  }

  @override
  Future<List<EmergencyContact>> getEmergencyContacts(String userId) async {
    return const [];
  }
}

void main() {
  late SOSNotifier notifier;
  late FakeSOSRepository repository;

  setUp(() {
    repository = FakeSOSRepository();
    final useCases = SOSUseCases(repository);
    notifier = SOSNotifier(useCases);
  });

  test('initial state is inactive', () {
    expect(notifier.state.status, SOSStatus.inactive);
    expect(notifier.state.activeEvent, isNull);
    expect(notifier.state.isLoading, false);
  });

  test('activateSOS changes status to active and sets activeEvent', () async {
    await notifier.activateSOS('user_1');
    
    expect(notifier.state.status, SOSStatus.active);
    expect(notifier.state.activeEvent, isNotNull);
    expect(notifier.state.activeEvent!.id, 'test_event');
    expect(repository.currentEvent, isNotNull);
  });

  test('cancelSOS changes status back to inactive and clears event', () async {
    await notifier.activateSOS('user_1');
    expect(notifier.state.status, SOSStatus.active);

    await notifier.cancelSOS();
    
    expect(notifier.state.status, SOSStatus.inactive);
    expect(notifier.state.activeEvent, isNull);
    expect(repository.currentEvent, isNull);
  });
}
