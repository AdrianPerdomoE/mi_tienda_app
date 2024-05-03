import 'package:flutter/material.dart';
//widgets
import "../../widgets/logout_button.dart";
//screens
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
    Container(
      color: Colors.blue,
      child: const Text("Perfil"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: const [LogoutButton()],
          title: const Text("Admin Home"),
        ),
        bottomNavigationBar: BottomNavigationBar(
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
              icon: Icon(Icons.person),
              label: "Perfil",
            ),
          ],
        ),
        body: _screens[_currentIndex]);
  }
}
