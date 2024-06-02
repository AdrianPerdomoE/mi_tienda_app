import 'package:flutter/material.dart';
import 'package:mi_tienda_app/views/screens/admin/admin_profile_screen.dart';
//widgets
import "../../widgets/logout_button.dart";
//screens
import 'admin_order_screen.dart';
import 'admin_product_screen.dart';

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
    const Text("Envios"),
    const AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: "Productos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: "Pedidos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: "Envios",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: "Perfil",
            ),
          ],
        ),
        body: _screens[_currentIndex]);
  }
}
