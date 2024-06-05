import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mi_tienda_app/global/placeholder_images_urls.dart';

import '../../models/cart_item.dart';
import '../../models/order.dart' as Custom_order;
import '../../models/order_states.dart';

class OrderProvider with ChangeNotifier {
  final List<Custom_order.Order> _orders = [
    Custom_order.Order(
      createdAt: Timestamp.now(),
      items: [
        CartItem(
          productId: 'product1',
          productName: 'Product 1',
          price: 20.0,
          quantity: 2,
          imageUrl: PlaceholderImagesUrls.png150Image,
          discount: 0.1,
        ),
        CartItem(
          productId: 'product2',
          productName: 'Product 2',
          price: 30.0,
          quantity: 1,
          imageUrl: PlaceholderImagesUrls.png150Image,
          discount: 0.2,
        ),
      ],
      id: 'order1',
      userId: 'teuvzpu1jbeWKC5uOcbXceEvVpd2',
      state: OrderStates.pendiente,
    ),
    Custom_order.Order(
      createdAt: Timestamp.now(),
      items: [
        CartItem(
          productId: 'product2',
          productName: 'Product 1',
          price: 20.0,
          quantity: 2,
          imageUrl: PlaceholderImagesUrls.png150Image,
          discount: 0.1,
        ),
        CartItem(
          productId: 'product2',
          productName: 'Product 2',
          price: 30.0,
          quantity: 1,
          imageUrl: PlaceholderImagesUrls.png150Image,
          discount: 0.2,
        ),
      ],
      id: 'order3',
      userId: 'teuvzpu1jbeWKC5uOcbXceEvVpd2',
      state: OrderStates.pagado,
    ),
    Custom_order.Order(
      createdAt: Timestamp.now(),
      items: [
        CartItem(
          productId: 'product3',
          productName: 'Product 3',
          price: 40.0,
          quantity: 3,
          imageUrl: PlaceholderImagesUrls.png150Image,
          discount: 0.3,
        ),
      ],
      id: 'order2',
      userId: 'rfGyu9vPPsauMZdyWUslt2pln6x1',
      state: OrderStates.fiado,
    ),
    // Agrega más órdenes aquí
  ];
  List<Custom_order.Order> get orders => _orders;

  Stream<List<Custom_order.Order>> getStream() async* {
    yield _orders;
  }

  void update(Custom_order.Order order) {
    final index = _orders.indexWhere((element) => element.id == order.id);
    _orders[index] = order;
    notifyListeners();
  }

  Stream<int> getPendingOrdersCount() async* {
    yield _orders
        .where((order) =>
            order.state == OrderStates.pendiente ||
            order.state == OrderStates.fiado)
        .length;
  }

  int getPendingOrdersCountSync(List<Custom_order.Order> localOrders) {
    return localOrders
        .where((order) =>
            order.state == OrderStates.pendiente ||
            order.state == OrderStates.fiado)
        .length;
  }
}
