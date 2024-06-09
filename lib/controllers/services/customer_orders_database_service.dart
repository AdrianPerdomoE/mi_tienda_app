import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_tienda_app/models/order.dart' as customer_order;

class CustomerOrdersDatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _ordersCollection = "Orders";
  final String _uid;

  CustomerOrdersDatabaseService(this._uid);

  Future<List<customer_order.Order>> getOrders() async {
    final orders = await _db
        .collection(_ordersCollection)
        .where('userId', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .get();
    return orders.docs
        .map((order) => customer_order.Order.fromJson(order.data()))
        .toList();
  }
}
