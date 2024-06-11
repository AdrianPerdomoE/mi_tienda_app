import 'package:flutter/material.dart';
import 'package:mi_tienda_app/views/screens/admin/admin_profile_screen.dart';
import 'package:provider/provider.dart';
//widgets
import '../../../controllers/providers/order_provider.dart';
import "../../widgets/logout_button.dart";
//screens
import '../shared/amount_custom_icon.dart';
import 'admin_order_screen.dart';
import 'admin_product_screen.dart';
import 'admin_shipments_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const AdminProductScreen(),
    const AdminOrderScreen(),
    const AdminShipmentsScreen(),
    const AdminProfileScreen(),
  ];
  late OrderProvider _orderProvider;
  @override
  Widget build(BuildContext context) {
    _orderProvider = context.watch<OrderProvider>();
    return Scaffold(
        appBar: AppBar(
          actions: const [LogoutButton()],
          title: const Text("Admin Home"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: "Productos",
            ),
            BottomNavigationBarItem(
              icon: StreamBuilder(
                  stream: _orderProvider.getPendingOrdersCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Icon(Icons.shopping_cart);
                    }
                    final pendingOrdersCount = snapshot.data;
                    final amount = pendingOrdersCount ?? 0;
                    return AmountCustomIcon(
                      underElement: const Icon(Icons.inventory),
                      amount: amount,
                    );
                  }),
              label: "Pedidos",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: "Envios",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: "Perfil",
            ),
          ],
        ),
        body: _screens[_currentIndex]);
  }
}
