import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/services/app_service.dart';

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
  final AppService appService = AppService();

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
    title: appService.appName,
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: appService.primaryColor,
        titleTextStyle: TextStyle(
          color: appService.backgroundColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: appService.backgroundColor),
      ),
      colorScheme: ColorScheme.fromSeed(
        primary: appService.primaryColor,
        seedColor: appService.primaryColor,
        secondary: appService.secondaryColor,
        tertiary: appService.accentColor,
        background: appService.backgroundColor,
      ),
      scaffoldBackgroundColor: appService.backgroundColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appService.primaryColor,
        selectedItemColor: appService.backgroundColor,
        unselectedItemColor: appService.backgroundColor,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        elevation: 100,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: appService.primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}
