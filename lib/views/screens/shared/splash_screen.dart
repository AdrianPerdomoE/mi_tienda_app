//packages

import "package:mi_tienda_app/controllers/services/distributor_database_service.dart";
import "package:mi_tienda_app/controllers/services/notification_service.dart";
import 'package:provider/provider.dart';

import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';

import "../../../controllers/services/cloud_storage_service.dart";
import '../../../controllers/services/user_database_service.dart';
import "../../../controllers/services/media_service.dart";
import "../../../controllers/services/navigation_service.dart";

class SplashScreen extends StatefulWidget {
  // clase que define el widget de la pantalla de inicio
  // ignore: non_constant_identifier_names

  // ignore: non_constant_identifier_names
  const SplashScreen({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  late AppDataProvider appDataProvider;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((_) {
      _setUp().then(
        (_) => onInitializationComplete(),
      );
    });
  }

// En el estado si quiero acceder a una propiedad o funcion de la clase padre, debo usar widget.variable
  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mi tienda App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: appDataProvider.primaryColor,
        ),
        scaffoldBackgroundColor: appDataProvider.backgroundColor,
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/images/logo.png"))),
          ),
        ),
      ),
    );
  }

  onInitializationComplete() {
    // Funcion que se ejecuta al completar la inicializacion
    GetIt.instance.get<NavigationService>().removeAndNavigateToRoute("/login");
  }

  Future<void> _setUp() async {
    _registerServices();
  }

  void _registerServices() {
    // Funcion que registra los servicios en GetIt
    if (!GetIt.instance.isRegistered<NavigationService>()) {
      GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    }
    if (!GetIt.instance.isRegistered<MediaService>()) {
      GetIt.instance.registerSingleton<MediaService>(MediaService());
    }
    if (!GetIt.instance.isRegistered<CloudStorageService>()) {
      GetIt.instance
          .registerSingleton<CloudStorageService>(CloudStorageService());
    }
    if (!GetIt.instance.isRegistered<UserDatabaseService>()) {
      GetIt.instance
          .registerSingleton<UserDatabaseService>(UserDatabaseService());
    }
    if (!GetIt.instance.isRegistered<DistributorDatabaseService>()) {
      GetIt.instance.registerSingleton<DistributorDatabaseService>(
          DistributorDatabaseService());
    }
    if (!GetIt.instance.isRegistered<NotificationService>()) {
      GetIt.instance
          .registerSingleton<NotificationService>(NotificationService());
    }
  }
}
