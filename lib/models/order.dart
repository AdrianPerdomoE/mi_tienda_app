import 'package:mi_tienda_app/models/cart_item.dart';
import './order_states.dart';

class Order {
  List<CartItem> items;
  String id;
  OrderStates state;

  Order({
    required this.items,
    required this.id,
    required this.state,
  });

  Order.fromJson(Map<String, dynamic> json)
      : items = json['items']
            .map<CartItem>((item) => CartItem.fromJson(item))
            .toList(),
        id = json['id'],
        state = OrderStates.values
            .firstWhere((element) => element.name == json['state']);
}
