import 'package:dummyexpense/features/category/domain/repositories/category_repository.dart';
import 'package:dummyexpense/features/transaction/domain/repositories/transaction_repository.dart';

class SyncService {
  final CategoryRepository categoryRepository;
  final TransactionRepository transactionRepository;

  SyncService({
    required this.categoryRepository,
    required this.transactionRepository,
  });

  /// Full sync workflow:
  /// Step A: Cloud Purge (deletions)
  /// Step B: Upload new data (categories first, then transactions)
  Future<SyncResult> syncAll() async {
    int deletedCategories = 0;
    int deletedTransactions = 0;
    int syncedCategories = 0;
    int syncedTransactions = 0;
    final errors = <String>[];

    // Step A: Purge deleted transactions first (to avoid FK issues)
    final purgeTransResult = await transactionRepository.purgeDeletedTransactions();
    purgeTransResult.fold(
      (f) => errors.add('Transaction purge: ${f.message}'),
      (ids) => deletedTransactions = ids.length,
    );

    // Then purge deleted categories
    final purgeCatResult = await categoryRepository.purgeDeletedCategories();
    purgeCatResult.fold(
      (f) => errors.add('Category purge: ${f.message}'),
      (ids) => deletedCategories = ids.length,
    );

    // Step B: Sync categories first
    final syncCatResult = await categoryRepository.syncCategories();
    syncCatResult.fold(
      (f) => errors.add('Category sync: ${f.message}'),
      (ids) => syncedCategories = ids.length,
    );

    // Then sync transactions
    final syncTransResult = await transactionRepository.syncTransactions();
    syncTransResult.fold(
      (f) => errors.add('Transaction sync: ${f.message}'),
      (ids) => syncedTransactions = ids.length,
    );

    return SyncResult(
      deletedCategories: deletedCategories,
      deletedTransactions: deletedTransactions,
      syncedCategories: syncedCategories,
      syncedTransactions: syncedTransactions,
      errors: errors,
    );
  }
}

class SyncResult {
  final int deletedCategories;
  final int deletedTransactions;
  final int syncedCategories;
  final int syncedTransactions;
  final List<String> errors;

  SyncResult({
    required this.deletedCategories,
    required this.deletedTransactions,
    required this.syncedCategories,
    required this.syncedTransactions,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
  int get totalSynced => syncedCategories + syncedTransactions;
  int get totalDeleted => deletedCategories + deletedTransactions;
}
