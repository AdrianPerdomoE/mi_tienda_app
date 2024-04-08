import 'package:mi_tienda_app/models/shipment_states.dart';

class Shippment {
  String id;
  String orderId;
  ShipmentStates state;
  DateTime creationDate;
  String address;

  Shippment({
    required this.id,
    required this.orderId,
    required this.state,
    required this.creationDate,
    required this.address,
  });

  Shippment.fromJson(Map<String, dynamic> json)
      : orderId = json['orderId'],
        id = json['id'],
        state = ShipmentStates.values
            .firstWhere((element) => element.name == json['state']),
        creationDate = DateTime.parse(json['creationDate']),
        address = json['address'];
}
