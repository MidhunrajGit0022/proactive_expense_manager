import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/category/data/datasources/category_local_datasource.dart';
import 'package:dummyexpense/features/category/data/datasources/category_remote_datasource.dart';
import 'package:dummyexpense/features/category/data/models/category_model.dart';
import 'package:dummyexpense/features/category/domain/entities/category_entity.dart';
import 'package:dummyexpense/features/category/domain/repositories/category_repository.dart';
import 'package:uuid/uuid.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;
  final CategoryRemoteDataSource remoteDataSource;
  final Uuid uuid;

  CategoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.uuid,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await localDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> addCategory(String name) async {
    try {
      final category = CategoryModel(
        id: uuid.v4(),
        name: name,
        isSynced: false,
        isDeleted: false,
      );
      await localDataSource.insertCategory(category);
      return Right(category);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await localDataSource.softDeleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> syncCategories() async {
    try {
      final unsynced = await localDataSource.getUnsyncedCategories();
      if (unsynced.isEmpty) return const Right([]);

      final syncedIds = await remoteDataSource.addCategories(unsynced);

     
      final unsyncedIdSet = unsynced.map((c) => c.id).toSet();
      final reportedSet = syncedIds.toSet();
      final notReported = unsyncedIdSet.difference(reportedSet);

      if (notReported.isNotEmpty) {
        try {
          final serverCategories = await remoteDataSource.getCategories();
          final serverIdSet = serverCategories.map((c) => c.id).toSet();
          final alreadyOnServer = notReported.intersection(serverIdSet);
          syncedIds.addAll(alreadyOnServer);
        } catch (_) {
        }
      }

      await localDataSource.markAsSynced(syncedIds);
      return Right(syncedIds);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> purgeDeletedCategories() async {
    try {
     
      await localDataSource.permanentlyDeleteUnsynced();

      final deleted = await localDataSource.getDeletedCategories();
      if (deleted.isEmpty) return const Right([]);
      final ids = deleted.map((c) => c.id).toList();
      final deletedIds = await remoteDataSource.deleteCategories(ids);
      await localDataSource.permanentlyDelete(deletedIds);
      return Right(deletedIds);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
