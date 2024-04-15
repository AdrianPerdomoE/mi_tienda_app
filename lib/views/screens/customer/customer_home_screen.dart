import 'package:flutter/material.dart';
import 'customer_profile_screen.dart';
//widgets
import "../../widgets/logout_button.dart";

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    Container(
      color: Colors.red,
      child: const Text("Productos"),
    ),
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
          title: const Text("Customer Home"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) {
            if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerProfileScreen(),
                ),
              );
            }
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
