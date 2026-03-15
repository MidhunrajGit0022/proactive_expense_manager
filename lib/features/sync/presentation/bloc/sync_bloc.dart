import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyexpense/features/sync/data/sync_service.dart';
import 'package:dummyexpense/features/sync/presentation/bloc/sync_event_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncService syncService;

  SyncBloc({required this.syncService}) : super(const SyncInitial()) {
    on<StartSyncEvent>(_onStartSync);
  }

  Future<void> _onStartSync(
    StartSyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(const SyncInProgress());
    try {
      final result = await syncService.syncAll();
    
      emit(SyncCompleted(result: result));
    } catch (e) {
      emit(SyncFailed(message: e.toString()));
    }
  }
}
