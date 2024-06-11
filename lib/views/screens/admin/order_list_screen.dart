import 'package:flutter/material.dart';
import 'package:mi_tienda_app/models/order.dart';
import 'package:provider/provider.dart';
import '../../../controllers/providers/order_provider.dart';
import '../../widgets/order_expasion_panel_list.dart';

class OrderListScreen extends StatefulWidget {
  final List<Order> orders;
  const OrderListScreen({super.key, required this.orders});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pedidos"),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: OrderExpansionPanelList(
              orders: widget.orders,
              onOrderStateChange: (order, state) {
                setState(() {
                  order.state = state;

                  context.read<OrderProvider>().update(order);
                });
              }),
        ));
  }
}
