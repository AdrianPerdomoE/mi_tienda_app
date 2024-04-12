import 'package:flutter/material.dart';
//widgets
import "../../widgets/logout_button.dart";

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [LogoutButton()],
        title: const Text("Admin Home"),
      ),
      body: const Center(
        child: Text("Admin Home"),
      ),
    );
  }
}
