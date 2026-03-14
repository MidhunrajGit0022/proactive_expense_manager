import 'package:dummyexpense/features/category/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    super.isSynced,
    super.isDeleted,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      isSynced: (map['is_synced'] as int?) == 1,
      isDeleted: (map['is_deleted'] as int?) == 1,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isSynced: true,
      isDeleted: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_synced': isSynced ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      'category_id': id,
      'name': name,
    };
  }
}
