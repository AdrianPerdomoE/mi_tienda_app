import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_tienda_app/models/cart.dart';
import 'package:mi_tienda_app/models/order.dart' as customer_order;
import 'package:mi_tienda_app/models/order_states.dart';
import 'package:mi_tienda_app/models/payment_method.dart';
import 'package:mi_tienda_app/models/shipment_method.dart';

class CustomerOrdersDatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _ordersCollection = "Orders";
  String _uid;
  DocumentSnapshot? _lastDocument;
  CustomerOrdersDatabaseService(this._uid);

  late bool nextAvailable;
  Future<List<customer_order.Order>> getOrders({bool nextPage = false}) async {
    Query query = _db
        .collection(_ordersCollection)
        .where('userId', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .limit(20);

    // Si estamos obteniendo la siguiente página, comienza después del último documento.
    if (nextPage && _lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final orders = await query.get() as QuerySnapshot<Map<String, dynamic>>;

    // Si hay resultados, guarda el último documento para la próxima página.
    if (orders.docs.isNotEmpty) {
      _lastDocument = orders.docs.last;
    }

    return orders.docs
        .map((order) =>
            customer_order.Order.fromJson({...order.data(), "id": order.id}))
        .toList();
  }

  setUid(String uid) {
    _uid = uid;
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
