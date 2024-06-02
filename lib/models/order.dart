import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_tienda_app/models/cart_item.dart';
import './order_states.dart';

class Order {
  List<CartItem> items;
  String id;
  String userId;
  OrderStates state;
  Timestamp createdAt;

  Order({
    required this.items,
    required this.id,
    required this.userId,
    required this.state,
    required this.createdAt,
  });

  amount() {
    double total = 0;
    for (var item in items) {
      total += item.price * (1 - item.discount) * item.quantity;
    }
    return total;
  }

  Order.fromJson(Map<String, dynamic> json)
      : items = json['items']
            .map<CartItem>((item) => CartItem.fromJson(item))
            .toList(),
        id = json['id'],
        userId = json['userId'],
        createdAt = json['createdAt'],
        state = OrderStates.values
            .firstWhere((element) => element.name == json['state']);
}
