import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../models/order.dart' as Custom_order;
import '../../models/order_states.dart';

const String collection = 'Orders';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Custom_order.Order>> getStream() {
    return _firestore.collection(collection).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) =>
                Custom_order.Order.fromJson({"id": doc.id, ...doc.data()}))
            .toList());
  }

  void update(Custom_order.Order order) {
    _firestore.collection(collection).doc(order.id).update(order.toJson());
    notifyListeners();
  }

  Stream<int> getPendingOrdersCount() {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Custom_order.Order.fromJson({"id": doc.id, ...doc.data()}))
          .toList()
          .where((order) =>
              order.state == OrderStates.pendiente ||
              order.state == OrderStates.fiado)
          .length;
    });
  }

  int getPendingOrdersCountSync(List<Custom_order.Order> localOrders) {
    return localOrders
        .where((order) =>
            order.state == OrderStates.pendiente ||
            order.state == OrderStates.fiado)
        .length;
  }
}
