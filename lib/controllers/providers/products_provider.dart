import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/products_database_service.dart';
import 'package:mi_tienda_app/models/product.dart';

class ProductsProvider extends ChangeNotifier {
  late final ProductsDatabaseService _productsDatabaseService;
  Stream<List<Product>> get products => _productsDatabaseService.products;
  String nameFilter = '';
  List<String> categoriesFilter = [];

  ProductsProvider() {
    _productsDatabaseService = GetIt.instance.get<ProductsDatabaseService>();
    getProducts();
  }

  void getProducts() {
    _productsDatabaseService.getAllProducts();
    notifyListeners();
  }

  void filterProductsByName(String name) {
    nameFilter = name;
    _productsDatabaseService.filterProductsByName(nameFilter);
    notifyListeners();
  }

  void addCategoryToFilter(String categoryId) {
    if (!categoriesFilter.contains(categoryId)) {
      categoriesFilter.add(categoryId);
    }
    _productsDatabaseService.filterProductsByCategories(categoriesFilter);
    notifyListeners();
  }

  void removeCategoryToFilter(String categoryId) {
    if (categoriesFilter.contains(categoryId)) {
      categoriesFilter.remove(categoryId);
    }
    _productsDatabaseService.filterProductsByCategories(categoriesFilter);
    notifyListeners();
  }
}
