import 'package:mi_tienda_app/models/cart_item.dart';

class Cart {
  List<CartItem> items;

  Cart({required this.items});

  Cart.fromJson(Map<String, dynamic> json)
      : items = json['items']
            .map<CartItem>((item) => CartItem.fromJson(item))
            .toList();

  toJson() {
    return {
      "items": items.map((item) => item.toJson()).toList(),
    };
  }

  int get totalItems {
    int totalItems = 0;
    for (var item in items) {
      totalItems += item.quantity;
    }
    return totalItems;
  }

  double get totalPrice {
    double totalPrice = 0;
    for (var item in items) {
      double discount = item.price * item.discount;
      double price = item.price - discount;
      totalPrice += price * item.quantity;
    }
    return totalPrice;
  }
}
