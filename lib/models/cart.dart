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
}
