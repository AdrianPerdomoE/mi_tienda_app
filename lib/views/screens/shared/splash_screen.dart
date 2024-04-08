//packages

import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "../../../controllers/services/cloud_storage_service.dart";
import "../../../controllers/services/database_service.dart";
import "../../../controllers/services/media_service.dart";
import "../../../controllers/services/navigation_service.dart";

class SplashScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names

  // ignore: non_constant_identifier_names
  const SplashScreen({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mi tienda App",
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(36, 35, 49, 1)),
          scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1)),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/images/logo.jpg"))),
          ),
        ),
      ),
    );
  }

  onInitializationComplete() {
    GetIt.instance.get<NavigationService>().removeAndNavigateToRoute("/login");
  }

  Future<void> _setUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    GetIt.instance.registerSingleton<MediaService>(MediaService());
    GetIt.instance
        .registerSingleton<CloudStorageService>(CloudStorageService());
    GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
  }
}
