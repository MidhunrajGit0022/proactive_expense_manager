import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/category/domain/entities/category_entity.dart';
import 'package:dummyexpense/features/category/domain/repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory(this.repository);

  Future<Either<Failure, CategoryEntity>> call(String name) {
    return repository.addCategory(name);
  }
}
