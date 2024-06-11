import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_tienda_app/models/shipment_states.dart';

class ShipmentsDatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _shipmentsCollection = "Shipments";

  Future<bool> createShipment(String orderId, String address) async {
    try {
      final Map<String, dynamic> shipmentData = {
        'orderId': orderId,
        'state': ShipmentStates.pendiente.name,
        'creationDate': DateTime.now(),
        'address': address,
      };

      final DocumentReference shipmentRef =
          await _db.collection(_shipmentsCollection).add(shipmentData);
      return shipmentRef.id.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
