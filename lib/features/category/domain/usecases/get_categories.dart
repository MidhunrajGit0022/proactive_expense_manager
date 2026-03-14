import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/category/domain/entities/category_entity.dart';
import 'package:dummyexpense/features/category/domain/repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}
