import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionEvent {
  const LoadTransactionsEvent();
}

class LoadRecentTransactionsEvent extends TransactionEvent {
  final int limit;

  const LoadRecentTransactionsEvent({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

class AddTransactionEvent extends TransactionEvent {
  final double amount;
  final String note;
  final String type;
  final String categoryId;

  const AddTransactionEvent({
    required this.amount,
    required this.note,
    required this.type,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [amount, note, type, categoryId];
}

class DeleteTransactionEvent extends TransactionEvent {
  final String id;

  const DeleteTransactionEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class LoadDashboardEvent extends TransactionEvent {
  const LoadDashboardEvent();
}
