import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/products_database_service.dart';
import 'package:mi_tienda_app/models/product.dart';

class ProductsProvider extends ChangeNotifier {
  late final ProductsDatabaseService _productsDatabaseService;
  Stream<List<Product>> products = const Stream.empty();
  String searchFilter = '';
  List<String> categoriesFilter = [];
  bool onlyVisible = true;

  ProductsProvider() {
    _productsDatabaseService = GetIt.instance.get<ProductsDatabaseService>();
  }

  void getProducts() {
    products = _productsDatabaseService.getProducts();

    if (categoriesFilter.isNotEmpty) {
      _filterProductsByCategories();
    }

    if (searchFilter.isNotEmpty) {
      _filterProductsByName();
    }

    if (onlyVisible) {
      _filterProductsByVisibility();
    }

    notifyListeners();
  }

  void setSearchFilter(String search) {
    searchFilter = search;
    getProducts();
  }

  void addCategoryToFilter(String categoryId) {
    if (!categoriesFilter.contains(categoryId)) {
      categoriesFilter.add(categoryId);
    }
    getProducts();
  }

  void removeCategoryToFilter(String categoryId) {
    if (categoriesFilter.contains(categoryId)) {
      categoriesFilter.remove(categoryId);
    }
    getProducts();
  }

  void resetCategoriesFilter() {
    categoriesFilter = [];
    getProducts();
  }

  void setOnlyVisible(bool value) {
    onlyVisible = value;
    getProducts();
  }

  void _filterProductsByName() {
    products = products.map((products) {
      return products
          .where((product) =>
              product.name.toLowerCase().contains(searchFilter.toLowerCase()))
          .toList();
    });
    notifyListeners();
  }

  void _filterProductsByCategories() {
    products = products.map((products) {
      return products
          .where((product) => categoriesFilter.contains(product.categoryId))
          .toList();
    });
  }

  void _filterProductsByVisibility() {
    products = products.map((products) {
      return products.where((product) => !product.hidden).toList();
    });
  }
}
