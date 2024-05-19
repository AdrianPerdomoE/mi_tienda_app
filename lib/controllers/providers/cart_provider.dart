import 'package:flutter/material.dart';
import 'package:mi_tienda_app/models/cart.dart';
import 'package:mi_tienda_app/models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  Stream<Cart> cart = Stream.value(Cart(items: []));
  Stream<int> cartCount = Stream.value(0);
  Stream<double> totalPrice = Stream.value(0);

  CartProvider() {
    getCart();
  }

  void getCart() {
    cart = Stream.value(Cart(items: [
      CartItem(
        productId: "1",
        productName: "CEPILLO SECADOR RED FLAG X 1 UD",
        price: 39990,
        quantity: 1,
        imageUrl:
            "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12004383.png",
        discount: 0.15,
      ),
      CartItem(
        productId: "2",
        productName: "SALCHICHA VIENA VIANDÉ 150 G",
        price: 3190,
        quantity: 2,
        imageUrl:
            "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12000314.png",
        discount: 0.3,
      ),
      CartItem(
        productId: "3",
        productName: "AVENA ALPINA VASO 250 ML",
        price: 3190,
        quantity: 5,
        imageUrl:
            "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12004951.png",
        discount: 0,
      ),
    ]));
    // get cart from database
    getCartCount();
    getTotal();
    notifyListeners();
  }

  void getCartCount() {
    // get cart count from database
    cartCount = Stream.value(8);
    notifyListeners();
  }

  void getTotal() {
    // get total from database
    totalPrice = Stream.value(600000);
    notifyListeners();
  }
}
