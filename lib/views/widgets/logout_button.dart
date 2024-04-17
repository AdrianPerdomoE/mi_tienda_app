import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
//provider
import '../../controllers/providers/authentication_provider.dart';
//services
import '../../controllers/services/navigation_service.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  late AuthenticationProvider _auth;
  late NavigationService _navigationService;

  @override
  Widget build(BuildContext context) {
    _auth = context.read<AuthenticationProvider>();
    _navigationService = GetIt.instance.get<NavigationService>();
    return _buildButton();
  }

  Widget _buildButton() {
    return IconButton(
        onPressed: () {
          _auth.logOut();
          _navigationService.removeAndNavigateToRoute('/login');
        },
        icon: const Icon(Icons.logout));
  }
}
