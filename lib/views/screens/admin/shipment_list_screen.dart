import 'package:flutter/material.dart';
import 'package:mi_tienda_app/models/shipment.dart';
import '../../widgets/shipment_expasion_panel_list.dart';
import 'package:provider/provider.dart';
import 'package:mi_tienda_app/controllers/providers/shipment_provider.dart';

class ShipmentListScreen extends StatefulWidget {
  final List<Shippment> shipments;
  const ShipmentListScreen({super.key, required this.shipments});

  @override
  State<ShipmentListScreen> createState() => _ShipmentListScreenState();
}

class _ShipmentListScreenState extends State<ShipmentListScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envíos"),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: ShipmentExpansionPanelList(
            shipments: widget.shipments,
            onShipmentStateChange: (shipment, state) {
              setState(() {
                shipment.state = state;

                context.read<ShipmentProvider>().updateShipment(shipment.id, shipment);
              });
            }
        ),
      ),
    );
  }
}