import 'package:dummyexpense/core/database/database_helper.dart';
import 'package:dummyexpense/features/transaction/data/models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<List<TransactionModel>> getRecentTransactions(int limit);
  Future<void> insertTransaction(TransactionModel transaction);
  Future<void> softDeleteTransaction(String id);
  Future<double> getTotalByType(String type);
  Future<double> getMonthlyTotal(String type);
  Future<List<TransactionModel>> getUnsyncedTransactions();
  Future<List<TransactionModel>> getDeletedTransactions();
  Future<void> markAsSynced(List<String> ids);
  Future<void> permanentlyDelete(List<String> ids);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final DatabaseHelper databaseHelper;

  TransactionLocalDataSourceImpl({required this.databaseHelper});

  /// SQL JOIN to fetch category name for each transaction
  static const String _joinQuery = '''
    SELECT t.*, c.name as category_name
    FROM transactions t
    LEFT JOIN categories c ON t.category_id = c.id
  ''';

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final db = await databaseHelper.database;
    final result = await db.rawQuery(
      '$_joinQuery WHERE t.is_deleted = 0 ORDER BY t.timestamp DESC',
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions(int limit) async {
    final db = await databaseHelper.database;
    final result = await db.rawQuery(
      '$_joinQuery WHERE t.is_deleted = 0 ORDER BY t.timestamp DESC LIMIT ?',
      [limit],
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await databaseHelper.database;
    await db.insert('transactions', transaction.toMap());
  }

  @override
  Future<void> softDeleteTransaction(String id) async {
    final db = await databaseHelper.database;
    await db.update(
      'transactions',
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<double> getTotalByType(String type) async {
    final db = await databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE type = ? AND is_deleted = 0',
      [type],
    );
    return (result.first['total'] as num).toDouble();
  }

  @override
  Future<double> getMonthlyTotal(String type) async {
    final db = await databaseHelper.database;
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1).toIso8601String();
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59).toIso8601String();
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE type = ? AND is_deleted = 0 AND timestamp >= ? AND timestamp <= ?',
      [type, monthStart, monthEnd],
    );
    return (result.first['total'] as num).toDouble();
  }

  @override
  Future<List<TransactionModel>> getUnsyncedTransactions() async {
    final db = await databaseHelper.database;
    final result = await db.rawQuery(
      '$_joinQuery WHERE t.is_synced = 0 AND t.is_deleted = 0',
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<List<TransactionModel>> getDeletedTransactions() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'transactions',
      where: 'is_deleted = ?',
      whereArgs: [1],
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<void> markAsSynced(List<String> ids) async {
    final db = await databaseHelper.database;
    for (final id in ids) {
      await db.update(
        'transactions',
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  @override
  Future<void> permanentlyDelete(List<String> ids) async {
    final db = await databaseHelper.database;
    for (final id in ids) {
      await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
    }
  }
}
