import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/providers/customer_orders_provider.dart';
import 'package:mi_tienda_app/models/order.dart';
import 'package:mi_tienda_app/views/widgets/order_expasion_panel_list.dart';
import 'package:provider/provider.dart';

class CustomerOrdersScreen extends StatefulWidget {
  const CustomerOrdersScreen({super.key});

  @override
  State<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen> {
  late AppDataProvider appDataProvider;
  late CustomerOrdersProvider customerOrdersProvider;

  @override
  void initState() {
    super.initState();
    final customerOrdersProvider = context.read<CustomerOrdersProvider>();
    customerOrdersProvider.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    customerOrdersProvider = context.watch<CustomerOrdersProvider>();

    return Scaffold(
      body: FutureBuilder(
        future: customerOrdersProvider.orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar los pedidos ${snapshot.error}'),
            );
          }

          List<Order> orders = snapshot.data as List<Order>;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    OrderExpansionPanelList(
                        orders: orders, onOrderStateChange: (order, state) {}),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
