import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/category/domain/repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteCategory(id);
  }
}
