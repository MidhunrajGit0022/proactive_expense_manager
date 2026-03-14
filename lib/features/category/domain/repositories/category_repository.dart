import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, CategoryEntity>> addCategory(String name);
  Future<Either<Failure, void>> deleteCategory(String id);
  Future<Either<Failure, List<String>>> syncCategories();
  Future<Either<Failure, List<String>>> purgeDeletedCategories();
}
