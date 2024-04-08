// packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
//services
import '../services/database_service.dart';
import '../services/navigation_service.dart';
//models
import '../../models/store_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final DatabaseService _databaseService;
  late final NavigationService _navigationService;
  late StoreUser user;
  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _databaseService.getUser(user.uid).then((snapshot) {
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;
          this.user = StoreUser.fromJson({"id": user.uid, ...userData});
          //_navigationService.removeAndNavigateToRoute('/home');
        });
      } else {
        //_navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }
  Future<void> loginUsingEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("Error loggin user in: ${e.message}");
    } catch (e) {
      print(e);
    }
  }
}
