import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/sos/sos_event.dart';
import '../../../domain/usecases/sos_usecases.dart';
import '../../../core/utils/providers.dart';

class SOSState {
  final SOSStatus status;
  final SOSEvent? activeEvent;
  final String? errorMessage;
  final bool isLoading;

  const SOSState({
    this.status = SOSStatus.inactive,
    this.activeEvent,
    this.errorMessage,
    this.isLoading = false,
  });

  SOSState copyWith({
    SOSStatus? status,
    SOSEvent? activeEvent,
    String? errorMessage,
    bool? isLoading,
  }) {
    return SOSState(
      status: status ?? this.status,
      activeEvent: activeEvent ?? this.activeEvent,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  SOSState clearActiveEvent() {
    return SOSState(
      status: SOSStatus.inactive,
      activeEvent: null,
      errorMessage: errorMessage,
      isLoading: isLoading,
    );
  }
}

class SOSNotifier extends StateNotifier<SOSState> {
  final SOSUseCases _useCases;

  SOSNotifier(this._useCases) : super(const SOSState());

  Future<void> activateSOS(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final event = await _useCases.activateSOS(userId);
      state = state.copyWith(
        status: SOSStatus.active,
        activeEvent: event,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> cancelSOS() async {
    if (state.activeEvent == null) return;
    
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _useCases.cancelSOS(state.activeEvent!.id);
      state = state.clearActiveEvent().copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final sosNotifierProvider = StateNotifierProvider<SOSNotifier, SOSState>((ref) {
  final useCases = ref.watch(sosUseCasesProvider);
  return SOSNotifier(useCases);
});
