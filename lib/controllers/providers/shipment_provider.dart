import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'package:mi_tienda_app/models/shipment_states.dart';
import 'package:mi_tienda_app/models/shipment.dart';

class ShipmentProvider extends ChangeNotifier {
  final List<Shippment> _shipments = [
    Shippment(
      id: 'shipment1',
      orderId: 'order1',
      state: ShipmentStates.pendiente,
      creationDate: DateTime.now(),
      address: 'Calle 123',
    ),
    Shippment(
      id: 'shipment3',
      orderId: 'order3',
      state: ShipmentStates.entregado,
      creationDate: DateTime.now(),
      address: 'Calle 456',
    ),
    Shippment(
      id: 'shipment4',
      orderId: 'order4',
      state: ShipmentStates.entregado,
      creationDate: DateTime.now(),
      address: 'Calle 789',
    ),
  ];

  List<Shippment> get shipments => _shipments;

  Stream<List<Shippment>> getStream() {
    return Stream.value(_shipments);
  }

  void addShipment(Shippment shipment) {
    _shipments.add(shipment);
    notifyListeners();
  }

  void updateShipment(String shipmentId, Shippment updatedShipment) {
    final index = _shipments.indexWhere((element) => element.id == shipmentId);
    if (index != -1) {
      _shipments[index] = updatedShipment;
      notifyListeners();
    }
  }

  void updateShipmentState(String shipmentId, ShipmentStates newState) {
    final index = _shipments.indexWhere((shipment) => shipment.id == shipmentId);
    if (index != -1) {
      _shipments[index].state = newState;
      notifyListeners();
    }
  }

  void cancelShipment(String shipmentId) {
    final index = _shipments.indexWhere((shipment) => shipment.id == shipmentId);
    if (index != -1) {
      _shipments[index].state = ShipmentStates.cancelado;
      notifyListeners();
    }
  }

  void removeShipment(String shipmentId) {
    _shipments.removeWhere((element) => element.id == shipmentId);
    notifyListeners();
  }

  List<Shippment> getShipmentsByStates(ShipmentStates state) {
    return _shipments.where((shipment) => shipment.state == state).toList();
  }
}