import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final String note;
  final String type; // 'credit' or 'debit'
  final String categoryId;
  final String? categoryName;
  final bool isSynced;
  final bool isDeleted;
  final DateTime timestamp;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.note,
    required this.type,
    required this.categoryId,
    this.categoryName,
    this.isSynced = false,
    this.isDeleted = false,
    required this.timestamp,
  });

  bool get isCredit => type == 'credit';
  bool get isDebit => type == 'debit';

  @override
  List<Object?> get props => [
        id,
        amount,
        note,
        type,
        categoryId,
        categoryName,
        isSynced,
        isDeleted,
        timestamp,
      ];
}
