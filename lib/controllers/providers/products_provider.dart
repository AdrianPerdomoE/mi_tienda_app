import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/products_database_service.dart';
import 'package:mi_tienda_app/models/product.dart';

class ProductsProvider extends ChangeNotifier {
  late final ProductsDatabaseService _productsDatabaseService;
  Stream<List<Product>> get products => _productsDatabaseService.products;
  
  ProductsProvider() {
    _productsDatabaseService = GetIt.instance.get<ProductsDatabaseService>();
  }
}