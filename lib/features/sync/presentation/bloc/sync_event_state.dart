import 'package:equatable/equatable.dart';
import 'package:dummyexpense/features/sync/data/sync_service.dart';

abstract class SyncEvent extends Equatable {
  const SyncEvent();
  @override
  List<Object?> get props => [];
}

class StartSyncEvent extends SyncEvent {
  const StartSyncEvent();
}

abstract class SyncState extends Equatable {
  const SyncState();
  @override
  List<Object?> get props => [];
}

class SyncInitial extends SyncState {
  const SyncInitial();
}

class SyncInProgress extends SyncState {
  const SyncInProgress();
}

class SyncCompleted extends SyncState {
  final SyncResult result;
  const SyncCompleted({required this.result});
  @override
  List<Object?> get props => [result];
}

class SyncFailed extends SyncState {
  final String message;
  const SyncFailed({required this.message});
  @override
  List<Object?> get props => [message];
}
