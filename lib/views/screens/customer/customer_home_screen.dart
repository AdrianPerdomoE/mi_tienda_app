import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/providers/cart_provider.dart';
import 'package:mi_tienda_app/views/screens/customer/customer_cart_screen.dart';
import 'package:mi_tienda_app/views/screens/customer/customer_orders_screen.dart';
import 'package:mi_tienda_app/views/screens/customer/customer_products_screen.dart';
import '../shared/amount_custom_icon.dart';
import 'customer_profile_screen.dart';
import 'package:provider/provider.dart';
//widgets
import "../../widgets/logout_button.dart";

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  late AppDataProvider appDataProvider;
  late CartProvider cartProvider;
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CustomerProductsScreen(),
    const CustomerCartScreen(),
    const CustomerOrdersScreen(),
    const CustomerProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    cartProvider = context.watch<CartProvider>();

    return Scaffold(
        appBar: AppBar(
          actions: const [LogoutButton()],
          title: Text(appDataProvider.appName),
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
              label: "Inicio",
            ),
            BottomNavigationBarItem(
              icon: StreamBuilder(
                stream: cartProvider.itemsCount,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Icon(Icons.shopping_cart);
                  }
                  final cartAmount = snapshot.data;
                  final amount = cartAmount ?? 0;
                  return AmountCustomIcon(
                    underElement: const Icon(Icons.shopping_cart),
                    amount: amount,
                  );
                },
              ),
              label: "Carrito",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: "Pedidos",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Perfil",
            ),
          ],
        ),
        body: _screens[_currentIndex]);
  }
}
