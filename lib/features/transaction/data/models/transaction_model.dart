import 'package:dummyexpense/features/transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.note,
    required super.type,
    required super.categoryId,
    super.categoryName,
    super.isSynced,
    super.isDeleted,
    required super.timestamp,
  });

  /// From SQLite JOIN result (includes category_name)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      note: map['note'] as String,
      type: map['type'] as String,
      categoryId: map['category_id'] as String,
      categoryName: map['category_name'] as String?,
      isSynced: (map['is_synced'] as int?) == 1,
      isDeleted: (map['is_deleted'] as int?) == 1,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  /// From API response
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String,
      type: json['type'] as String,
      categoryId: json['category_id'] as String? ?? '',
      categoryName: json['category'] as String?,
      isSynced: true,
      isDeleted: false,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'type': type,
      'category_id': categoryId,
      'is_synced': isSynced ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'type': type,
      'category_id': categoryId,
      'timestamp': timestamp.toIso8601String().replaceFirst('T', ' ').split('.').first,
    };
  }
}
