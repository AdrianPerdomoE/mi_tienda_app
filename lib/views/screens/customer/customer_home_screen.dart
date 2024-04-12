import 'package:flutter/material.dart';
//widgets
import "../../widgets/logout_button.dart";

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [LogoutButton()],
        title: const Text("Customer Home"),
      ),
      body: const Center(
        child: Text("Customer Home"),
      ),
    );
  }
}
