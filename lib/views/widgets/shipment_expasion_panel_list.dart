import 'package:flutter/material.dart';
import 'package:mi_tienda_app/models/shipment.dart';
import 'package:mi_tienda_app/models/shipment_states.dart';
import 'package:mi_tienda_app/controllers/providers/order_provider.dart';
import 'package:provider/provider.dart';

class ShipmentExpansionPanelList extends StatefulWidget {
  final List<Shippment> shipments;
  final void Function(Shippment, ShipmentStates) onShipmentStateChange;

  const ShipmentExpansionPanelList(
      {Key? key, required this.shipments, required this.onShipmentStateChange})
      : super(key: key);

  @override
  State<ShipmentExpansionPanelList> createState() =>
      _ShipmentExpansionPanelListState();
}

class _ShipmentExpansionPanelListState
    extends State<ShipmentExpansionPanelList> {
  late List<bool> _data;
  @override
  void initState() {
    super.initState();
    _data = List.generate(widget.shipments.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    List<Widget> orderItemsWidgets = [];

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index] = isExpanded;
        });
      },
      children: widget.shipments
          .map<ExpansionPanel>((Shippment shipment) => ExpansionPanel(
                isExpanded: _data[widget.shipments.indexOf(shipment)],
                headerBuilder: (BuildContext context, bool isExpanded) {
                  DateTime date = shipment.creationDate.toLocal();
                  return ListTile(
                    title: Text(
                        "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}:${date.second}"),
                    subtitle: Row(
                      children: [
                        const Text(
                          "Estado: ",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<ShipmentStates>(
                          value: shipment.state,
                          elevation: 16,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (state) {
                            widget.onShipmentStateChange(shipment, state!);
                          },
                          items: ShipmentStates.values
                              .map((state) => DropdownMenuItem(
                                    value: state,
                                    child: Text(state.name),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
                body: Wrap(
                  children: orderItemsWidgets,
                ),
              ))
          .toList(),
    );
  }
}
