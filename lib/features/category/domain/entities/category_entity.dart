import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final bool isSynced;
  final bool isDeleted;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.isSynced = false,
    this.isDeleted = false,
  });

  @override
  List<Object?> get props => [id, name, isSynced, isDeleted];
}
