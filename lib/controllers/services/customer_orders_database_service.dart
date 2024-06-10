import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_tienda_app/models/cart.dart';
import 'package:mi_tienda_app/models/order.dart' as customer_order;
import 'package:mi_tienda_app/models/order_states.dart';
import 'package:mi_tienda_app/models/payment_method.dart';
import 'package:mi_tienda_app/models/shipment_method.dart';

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
        .map((order) =>
            customer_order.Order.fromJson({...order.data(), "id": order.id}))
        .toList();
  }

  Future<bool> createOrder(Cart cart, PaymentMethod paymentMethod,
      ShipmentMethod shipmentMethod) async {
    try {
      OrderStates state = OrderStates.pendiente;

      switch (paymentMethod) {
        case PaymentMethod.enLinea:
          state = OrderStates.pagado;
          break;
        case PaymentMethod.fiado:
          state = OrderStates.fiado;
          break;
        case PaymentMethod.contraEntrega:
          state = OrderStates.pendiente;
          break;
      }

      final Map<String, dynamic> orderData = {
        'items': cart.items.map((item) => item.toJson()).toList(),
        'userId': _uid,
        'state': state.name,
        'createdAt': DateTime.now()
      };

      final DocumentReference orderRef =
          await _db.collection(_ordersCollection).add(orderData);

      return orderRef.id.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
