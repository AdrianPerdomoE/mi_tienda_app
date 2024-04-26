import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import "package:firebase_core/firebase_core.dart";
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
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider<AppDataProvider>(
            create: (context) => AppDataProvider()),
      ],
      child: Builder(
        builder: (context) => _buildMaterialApp(context),
      ),
    );
  }
}

MaterialApp _buildMaterialApp(BuildContext context) {
  AppDataProvider appDataProvider = context.watch<AppDataProvider>();
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
    title: appDataProvider.appName,
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: appDataProvider.primaryColor,
        titleTextStyle: TextStyle(
          color: appDataProvider.backgroundColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: appDataProvider.backgroundColor),
      ),
      colorScheme: ColorScheme.fromSeed(
        primary: appDataProvider.primaryColor,
        seedColor: appDataProvider.primaryColor,
        secondary: appDataProvider.secondaryColor,
        tertiary: appDataProvider.accentColor,
        background: appDataProvider.backgroundColor,
      ),
      scaffoldBackgroundColor: appDataProvider.backgroundColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appDataProvider.primaryColor,
        selectedItemColor: appDataProvider.backgroundColor,
        unselectedItemColor: appDataProvider.backgroundColor,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        elevation: 100,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: appDataProvider.primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}
