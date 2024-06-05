import 'package:flutter/material.dart';
import 'package:mi_tienda_app/models/order.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/order_provider.dart';
import '../../../models/order_states.dart';

class OrderListScreen extends StatefulWidget {
  final List<Order> orders;
  const OrderListScreen({super.key, required this.orders});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late List<bool> _data;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _data = List.generate(widget.orders.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pedidos"),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: ExpansionPanelList(
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
                              "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}:${date.second} - Total: ${order.amount()} \$"),
                          subtitle: Row(
                            children: [
                              const Text(
                                "Estado: ",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              DropdownButton<OrderStates>(
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
                                  setState(() {
                                    order.state = state!;

                                    context.read<OrderProvider>().update(order);
                                  });
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
                                "Precio unitario (descuento incluido): ${item.price * (1 - item.discount)} \$"),
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
          ),
        ));
  }
}
