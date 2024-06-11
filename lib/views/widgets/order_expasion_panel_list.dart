import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/utils/custom_formats.dart';
import '../../models/order.dart';
import '../../models/order_states.dart';

class OrderExpansionPanelList extends StatefulWidget {
  final List<Order> orders;
  final Function(Order, OrderStates) onOrderStateChange;
  final bool canChangeState;
  const OrderExpansionPanelList(
      {super.key,
      required this.orders,
      required this.onOrderStateChange,
      required this.canChangeState});

  @override
  State<OrderExpansionPanelList> createState() =>
      _OrderExpansionPanelListState();
}

class _OrderExpansionPanelListState extends State<OrderExpansionPanelList> {
  late List<bool> _data;
  @override
  void initState() {
    super.initState();
    _data = List.generate(widget.orders.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index] = isExpanded;
        });
      },
      children: widget.orders
          .map<ExpansionPanel>((order) => ExpansionPanel(
                isExpanded: _data[widget.orders.indexOf(order)],
                headerBuilder: (context, isExpanded) {
                  DateTime date = order.createdAt.toDate().toLocal();
                  return ListTile(
                    title: Text(
                        "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}:${date.second} - Total: ${toCOP(order.amount())}"),
                    subtitle: Row(
                      children: [
                        const Text(
                          "Estado: ",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        !widget.canChangeState
                            ? Text(
                                order.state.name,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )
                            : DropdownButton<OrderStates>(
                                value: order.state,
                                elevation: 16,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                underline: Container(
                                  height: 0,
                                ),
                                onChanged: (state) {
                                  widget.onOrderStateChange(order, state!);
                                },
                                items: OrderStates.values
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
                  children: order.items.map((item) {
                    return ListTile(
                      title: Text(item.productName),
                      subtitle: Text(
                          "Precio unitario (descuento incluido): ${toCOP(item.price * (1 - item.discount))}"),
                      leading: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          image: DecorationImage(
                            image: NetworkImage(item.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      trailing: Text("Cantidad: ${item.quantity}",
                          style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                ),
              ))
          .toList(),
    );
  }
}
