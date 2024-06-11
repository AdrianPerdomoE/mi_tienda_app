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
  final ScrollController _scrollController = ScrollController();
  late double _height;
  late double _width;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrders();
    });
    _scrollController.addListener(() {
      if (!customerOrdersProvider.nextAvailable) {
        return;
      }
      double max = _scrollController.position.maxScrollExtent;
      double current = _scrollController.position.pixels;
      if (max <= current + _height / 2) {
        if (_loading) return;

        getOrders().then((value) {
          createAnimate(current + 50);
        });
      }
    });
  }

  createAnimate(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> getOrders() async {
    setState(() {
      _loading = true;
    });
    await customerOrdersProvider.getOrders();
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    customerOrdersProvider.orders.clear();
    customerOrdersProvider.getOrders(next: false);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    appDataProvider = context.watch<AppDataProvider>();
    customerOrdersProvider = context.watch<CustomerOrdersProvider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return customerOrdersProvider.refresh();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: _height),
            child: Stack(
              children: [_buildOrderList(), _buildCircularProgressIndicator()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return Column(
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
        customerOrdersProvider.orders.isEmpty
            ? const Center(
                child: Text('No tienes pedidos'),
              )
            : _buildOrders()
      ],
    );
  }

  Widget _buildOrders() {
    return OrderExpansionPanelList(
        orders: customerOrdersProvider.orders,
        onOrderStateChange: (_, v) {},
        canChangeState: false);
  }

  Widget _buildCircularProgressIndicator() {
    return _loading
        ? Positioned(
            bottom: 20,
            left: _width / 2 - 10,
            child: const CircularProgressIndicator(),
          )
        : const SizedBox();
  }
}
