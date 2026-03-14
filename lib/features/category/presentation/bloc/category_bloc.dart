import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyexpense/features/category/domain/usecases/get_categories.dart';
import 'package:dummyexpense/features/category/domain/usecases/add_category.dart';
import 'package:dummyexpense/features/category/domain/usecases/delete_category.dart';
import 'package:dummyexpense/features/category/presentation/bloc/category_event.dart';
import 'package:dummyexpense/features/category/presentation/bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;
  final AddCategory addCategory;
  final DeleteCategory deleteCategory;

  CategoryBloc({
    required this.getCategories,
    required this.addCategory,
    required this.deleteCategory,
  }) : super(const CategoryInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    final result = await getCategories();
    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (categories) => emit(CategoryLoaded(categories: categories)),
    );
  }

  Future<void> _onAddCategory(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final result = await addCategory(event.name);
    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (_) => add(const LoadCategoriesEvent()),
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final result = await deleteCategory(event.id);
    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (_) => add(const LoadCategoriesEvent()),
    );
  }
}
