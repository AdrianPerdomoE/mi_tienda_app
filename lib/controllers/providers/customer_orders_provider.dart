import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/customer_orders_database_service.dart';
import 'package:mi_tienda_app/models/cart.dart';
import 'package:mi_tienda_app/models/order.dart' as customer_order;
import 'package:mi_tienda_app/models/payment_method.dart';
import 'package:mi_tienda_app/models/shipment_method.dart';

class CustomerOrdersProvider extends ChangeNotifier {
  late final CustomerOrdersDatabaseService _ordersDatabaseService;
  Future<List<customer_order.Order>> orders = Future.value([]);
  PaymentMethod? _selectedPaymentMethod;
  ShipmentMethod? _selectedShipmentMethod;
  get selectedPaymentMethod => _selectedPaymentMethod;
  get selectedShipmentMethod => _selectedShipmentMethod;

  CustomerOrdersProvider() {
    _ordersDatabaseService =
        GetIt.instance.get<CustomerOrdersDatabaseService>();
  }

  Future<void> getOrders() async {
    orders = _ordersDatabaseService.getOrders();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setPaymentMethod(PaymentMethod? paymentMethod) {
    _selectedPaymentMethod = paymentMethod;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setShipmentMethod(ShipmentMethod? shipmentMethod) {
    _selectedShipmentMethod = shipmentMethod;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<bool> createOrder(Cart cart) async {
    if (_selectedPaymentMethod == null || _selectedShipmentMethod == null) {
      return false;
    }
    
    return _ordersDatabaseService.createOrder(
      cart,
      _selectedPaymentMethod!,
      _selectedShipmentMethod!,
    );
    
  }
}
