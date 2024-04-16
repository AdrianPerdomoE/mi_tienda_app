// packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
//services
import '../services/user_database_service.dart';
import '../services/navigation_service.dart';
//models
import '../../models/store_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final UserDatabaseService _databaseService;
  late final NavigationService _navigationService;
  late IUser user;
  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<UserDatabaseService>();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _databaseService.getUser(user.uid).then((value) {
          if (value != null) {
            this.user = value;
            notifyListeners();
            _navigationService
                .removeAndNavigateToRoute('/${value.role.toLowerCase()}-home');
          } else {
            _auth.signOut();
          }
        });
      } else {
        _navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }
  Future<void> loginUsingEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("User logged in");
    } on FirebaseAuthException catch (e) {
      print("Error loggin user in: ${e.message}");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUsingEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credentials.user!.uid;
    } on FirebaseAuthException {
      print('Error registering user');
    } catch (e) {
      print("Error registering user: ${e}");
    }
    return null;
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
