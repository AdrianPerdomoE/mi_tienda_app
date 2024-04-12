import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
//screens
import 'views/screens/customer/customer_home_screen.dart';
import 'views/screens/admin/admin_home_screen.dart';
import 'views/screens/shared/login_screen.dart';
import './views/screens/shared/splash_screen.dart';
import 'views/screens/shared/register_screen.dart';
//packages

//services
import './controllers/services/navigation_service.dart';
//providers
import './controllers/providers/authentication_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (context) => AuthenticationProvider())
      ],
      child: _buildMaterialApp(context),
    );
  }
}

MaterialApp _buildMaterialApp(BuildContext context) {
  return MaterialApp(
    navigatorKey: NavigationService.navigatorKey,
    routes: {
      '/': (context) => SplashScreen(
            key: UniqueKey(),
          ),
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/admin-home': (context) => const AdminHomeScreen(),
      '/customer-home': (context) => const CustomerHomeScreen(),
    },
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
    title: "Mi tienda App",
    theme: ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: const Color.fromRGBO(36, 35, 49, 1)),
      scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromRGBO(30, 29, 37, 1),
      ),
    ),
  );
}
