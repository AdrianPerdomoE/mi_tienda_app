import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/cart_database_service.dart';
import 'package:mi_tienda_app/controllers/services/products_database_service.dart';
import 'package:mi_tienda_app/models/cart.dart';
import 'package:mi_tienda_app/models/cart_item.dart';
import 'package:mi_tienda_app/models/product.dart';

class CartProvider extends ChangeNotifier {
  late final CartDatabaseService _cartDatabaseService;
  late final ProductsDatabaseService _productsDatabaseService;
  Stream<Cart> cart = const Stream.empty();
  Stream<int> itemsCount = const Stream.empty();
  Stream<double> totalPrice = const Stream.empty();

  CartProvider() {
    _cartDatabaseService = GetIt.instance.get<CartDatabaseService>();
    _productsDatabaseService = GetIt.instance.get<ProductsDatabaseService>();
  }

  void getCart() {
    cart = _cartDatabaseService.getCart();
    getCartItemsCount();
    getCartTotalPrice();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void getCartItemsCount() {
    itemsCount = _cartDatabaseService.getCartItemsCount();
  }

  void getCartTotalPrice() {
    totalPrice = _cartDatabaseService.getCartTotalPrice();
  }

  Stream<CartItem> getCartItem(String productId) {
    return _cartDatabaseService.getCartItem(productId);
  }

  Future<bool> isProductInCart(String productId) async {
    return await _cartDatabaseService.isProductInCart(productId);
  }

  // Verifica si un producto existe y tiene stock (stock > 0)
  Future<Product> _verifyProduct(String productId) async {
    final product = await _productsDatabaseService.getProduct(productId);
    if (product == null) {
      throw Exception("Producto no encontrado.");
    } else if (product.stock < 1) {
      throw Exception("No hay unidades disponibles de este producto.");
    } else if (await _cartDatabaseService.isThereStock(
            productId, product.stock) ==
        false) {
      throw Exception(
          "No hay más de ${product.stock} unidades disponibles de este producto.");
    } else {
      return product;
    }
  }

  Future<void> addItemToCart(String productId) async {
    try {
      final product = await _verifyProduct(productId);
      await _cartDatabaseService.addItemToCart(product);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeItemFromCart(String productId) async {
    await _cartDatabaseService.removeItemFromCart(productId);
  }

  Future<void> increaseOneItemToCart(String productId) async {
    try {
      await _verifyProduct(productId);
      await _cartDatabaseService.intOrDecItemQuantity(productId, 1);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> decreaseOneItemFromCart(String productId) async {
    await _cartDatabaseService.intOrDecItemQuantity(productId, -1);
  }

  Future<void> clearCart() async {
    await _cartDatabaseService.clearCart();
  }
}
