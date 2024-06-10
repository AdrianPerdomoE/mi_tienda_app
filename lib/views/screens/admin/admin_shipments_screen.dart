import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mi_tienda_app/controllers/services/navigation_service.dart';
import 'package:mi_tienda_app/views/screens/admin/shipment_list_screen.dart';

import 'package:provider/provider.dart';
import 'package:mi_tienda_app/controllers/providers/shipment_provider.dart';

import 'package:mi_tienda_app/models/shipment.dart';

class AdminShipmentsScreen extends StatefulWidget {
  const AdminShipmentsScreen({super.key});

  @override
  State<AdminShipmentsScreen> createState() => _AdminShipmentsScreenState();
}

class _AdminShipmentsScreenState extends State<AdminShipmentsScreen> {

  late ShipmentProvider _shipmentProvider;
  final NavigationService _navigationService = GetIt.instance.get<NavigationService>();
  @override
  Widget build(BuildContext context) {
    _shipmentProvider = context.watch<ShipmentProvider>();
    return StreamBuilder(
      stream: _shipmentProvider.getStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar los envíos"));
        } else {
          final shipments = snapshot.data as List<Shippment>;
          return ListView.builder(
            itemCount: shipments.length,
            itemBuilder: (context, index) {
              final shipment = shipments[index];
              return ListTile(
                title: Text(shipment.id),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Ver detalles'),
                        onTap: () {
                          _navigationService.navigateToPage(ShipmentListScreen(shipments: [shipment]));
                        },
                    ),
                    PopupMenuItem(
                      child: Text('Cancelar envío'),
                      onTap: () {
                        _shipmentProvider.cancelShipment(shipment.id);
                      }
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    );
  }
}