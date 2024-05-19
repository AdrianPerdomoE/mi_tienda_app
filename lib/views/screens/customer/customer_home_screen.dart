import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/providers/cart_provider.dart';
import 'package:mi_tienda_app/views/screens/customer/customer_cart_screen.dart';
import 'package:mi_tienda_app/views/screens/customer/customer_products_screen.dart';
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
              icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                StreamBuilder<Object>(
                  stream: cartProvider.cartCount,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    final int count = snapshot.data as int;

                    if (count == 0) {
                      return const SizedBox();
                    }
                    return Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                      color: appDataProvider.accentColor,
                      borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                      ),
                      child: Text(
                      count.toString(),
                      style: TextStyle(
                        color: appDataProvider.backgroundColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      ),
                    ),
                    );
                  }
                ),
              ],
              ),
              label: "Carrito",
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
