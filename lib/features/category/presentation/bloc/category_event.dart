import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends CategoryEvent {
  const LoadCategoriesEvent();
}

class AddCategoryEvent extends CategoryEvent {
  final String name;

  const AddCategoryEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

class DeleteCategoryEvent extends CategoryEvent {
  final String id;

  const DeleteCategoryEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
