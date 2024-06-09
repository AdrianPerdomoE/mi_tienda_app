import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/customer_orders_database_service.dart';
import 'package:mi_tienda_app/global/placeholder_images_urls.dart';
import 'package:mi_tienda_app/models/cart_item.dart';
import 'package:mi_tienda_app/models/order.dart' as customer_order;
import 'package:mi_tienda_app/models/order_states.dart';

class CustomerOrdersProvider extends ChangeNotifier {
  late final CustomerOrdersDatabaseService _ordersDatabaseService;
  List<customer_order.Order> orders = [
    customer_order.Order(
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
    customer_order.Order(
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
    customer_order.Order(
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

  CustomerOrdersProvider() {
    _ordersDatabaseService = GetIt.instance.get<CustomerOrdersDatabaseService>();
  }

  void getOrders() {
    _ordersDatabaseService.getOrders().then((value) {
      orders = value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    });
  }
}

