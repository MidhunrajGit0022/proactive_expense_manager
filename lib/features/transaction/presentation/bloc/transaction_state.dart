import 'package:equatable/equatable.dart';
import 'package:dummyexpense/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;

  const TransactionLoaded({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class DashboardLoaded extends TransactionState {
  final double totalIncome;
  final double totalExpense;
  final double monthlyExpense;
  final double budgetLimit;
  final List<TransactionEntity> recentTransactions;

  const DashboardLoaded({
    required this.totalIncome,
    required this.totalExpense,
    required this.monthlyExpense,
    required this.budgetLimit,
    required this.recentTransactions,
  });

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        monthlyExpense,
        budgetLimit,
        recentTransactions,
      ];
}

class TransactionAdded extends TransactionState {
  const TransactionAdded();
}

class TransactionDeleted extends TransactionState {
  const TransactionDeleted();
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError({required this.message});

  @override
  List<Object?> get props => [message];
}
