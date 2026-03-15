import 'package:dummyexpense/core/error/exceptions.dart';
import 'package:dummyexpense/core/network/api_client.dart';
import 'package:dummyexpense/core/utils/constants.dart';
import 'package:dummyexpense/features/category/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<String>> addCategories(List<CategoryModel> categories);
  Future<List<String>> deleteCategories(List<String> ids);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient apiClient;

  CategoryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get(AppConstants.categoriesPath);
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      final list = response.data['categories'] as List?;
      return list?.map((e) => CategoryModel.fromJson(e)).toList() ?? [];
    }
    throw ServerException(
      message: response.data['message'] ?? 'Failed to fetch categories',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<List<String>> addCategories(List<CategoryModel> categories) async {
    
    final List<String> syncedIds = [];
    for (final category in categories) {
      try {
        final response = await apiClient.post(
          AppConstants.addCategoryPath,
          data: category.toApiJson(),
        );
        if (response.statusCode == 200 && response.data['status'] == 'success') {
          final ids = response.data['synced_ids'] as List?;
          if (ids != null) {
            syncedIds.addAll(ids.map((e) => e.toString()));
          }
        } else if (response.statusCode == 200 || response.statusCode == 201) {
          syncedIds.add(category.id);
        }
      
      } catch (_) {
        continue;
      }
    }
    return syncedIds;
  }

  @override
  Future<List<String>> deleteCategories(List<String> ids) async {
    final response = await apiClient.delete(
      AppConstants.deleteCategoriesPath,
      data: {'ids': ids},
    );
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      final deletedIds = response.data['deleted_ids'] as List?;
      return deletedIds?.map((e) => e.toString()).toList() ?? [];
    }
    if (response.statusCode == 404) {
      return ids;
    }
    throw ServerException(
      message: response.data['message'] ?? 'Failed to delete categories',
      statusCode: response.statusCode,
    );
  }
}

