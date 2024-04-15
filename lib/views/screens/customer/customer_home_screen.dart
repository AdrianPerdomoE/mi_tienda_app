import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/services/app_service.dart';
import 'customer_profile_screen.dart';
//widgets
import "../../widgets/logout_button.dart";

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final AppService appService = AppService();
  int _currentIndex = 0;
  final List<Widget> _screens = [
    Container(
      color: Colors.red,
      child: const Text("Inicio"),
    ),
    const CustomerProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: const [LogoutButton()],
          title: Text(appService.appName),
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
              label: "Inicio",
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
