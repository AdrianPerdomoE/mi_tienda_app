import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/categories_database_service.dart';
import 'package:mi_tienda_app/models/category.dart';

class CategoriesProvider extends ChangeNotifier {
  late final CategoriesDatabaseService _categoriesDatabaseService;
  Stream<List<Category>> get categories => _categoriesDatabaseService.categories;

  CategoriesProvider() {
    _categoriesDatabaseService = GetIt.instance.get<CategoriesDatabaseService>();
  }
}