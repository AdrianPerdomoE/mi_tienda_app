import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/providers/customer_orders_provider.dart';
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
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Mis pedidos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OrderExpansionPanelList(
              orders: customerOrdersProvider.orders,
              onOrderStateChange: (order, state) {}),
        ],
      ),
    );
  }
}
