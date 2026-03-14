import 'package:dummyexpense/core/database/database_helper.dart';
import 'package:dummyexpense/features/category/data/models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel category);
  Future<void> softDeleteCategory(String id);
  Future<List<CategoryModel>> getUnsyncedCategories();
  Future<List<CategoryModel>> getDeletedCategories();
  Future<void> markAsSynced(List<String> ids);
  Future<void> permanentlyDelete(List<String> ids);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper databaseHelper;

  CategoryLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'categories',
      where: 'is_deleted = ?',
      whereArgs: [0],
    );
    return result.map((map) => CategoryModel.fromMap(map)).toList();
  }

  @override
  Future<void> insertCategory(CategoryModel category) async {
    final db = await databaseHelper.database;
    await db.insert('categories', category.toMap());
  }

  @override
  Future<void> softDeleteCategory(String id) async {
    final db = await databaseHelper.database;
    await db.update(
      'categories',
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<CategoryModel>> getUnsyncedCategories() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'categories',
      where: 'is_synced = ? AND is_deleted = ?',
      whereArgs: [0, 0],
    );
    return result.map((map) => CategoryModel.fromMap(map)).toList();
  }

  @override
  Future<List<CategoryModel>> getDeletedCategories() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'categories',
      where: 'is_deleted = ?',
      whereArgs: [1],
    );
    return result.map((map) => CategoryModel.fromMap(map)).toList();
  }

  @override
  Future<void> markAsSynced(List<String> ids) async {
    final db = await databaseHelper.database;
    for (final id in ids) {
      await db.update(
        'categories',
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
      await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    }
  }
}
