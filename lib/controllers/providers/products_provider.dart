import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/products_database_service.dart';
import 'package:mi_tienda_app/models/product.dart';

class ProductsProvider extends ChangeNotifier {
  late final ProductsDatabaseService _productsDatabaseService;
  Stream<List<Product>> get products => _productsDatabaseService.products;
  List<String> categoriesToFilter = [];
  
  ProductsProvider() {
    getProducts();
  }

  void getProducts() {
    _productsDatabaseService = GetIt.instance.get<ProductsDatabaseService>();
    notifyListeners();
  }

  void filterProductsByName(String name) {
    _productsDatabaseService.filterProductsByName(name);
    notifyListeners();
  }

  void addCategoryToFilter(String categoryId) {
    if (!categoriesToFilter.contains(categoryId)) {
      categoriesToFilter.add(categoryId);
    }
    _productsDatabaseService.filterProductsByCategories(categoriesToFilter);
    notifyListeners();
  }

  void removeCategoryToFilter(String categoryId) {
    if (categoriesToFilter.contains(categoryId)) {
      categoriesToFilter.remove(categoryId);
    }
    _productsDatabaseService.filterProductsByCategories(categoriesToFilter);
    notifyListeners();
  }
}