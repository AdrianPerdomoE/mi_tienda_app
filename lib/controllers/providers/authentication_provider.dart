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

  Future<void> updateEmail(String newEmail) async {
    try {
      user.email = newEmail;
      await _auth.currentUser!.updateEmail(
          newEmail); //esta deprecado para por motivos academicos, se deja asi, ya que no es posible actualiarzlo luego de verificar el numero, ya que no se ingresa siempre con correos reales
      await _databaseService.updateUserData(user);
      logOut();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> reauthenticateWithPassword(String password) async {
    try {
      // Re-authenticate the user with their previous password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email,
        password: password,
      );
      await _auth.currentUser!.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      // Update the password
      await _auth.currentUser!.updatePassword(newPassword);
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          //Casos de errores para mensajes personalizados
          case 'requires-recent-login':
            print('Error: Requiere iniciar sesión nuevamente');
            break;
          case 'weak-password':
            print('Error: La contraseña es muy débil');
            break;
          case 'user-mismatch':
            print('Error: Las credenciales no coinciden');
            break;
          case 'user-not-found':
            print('Error: Usuario no encontrado');
            break;
          case 'wrong-password':
            print('Error: Contraseña incorrecta');
            break;
          case 'invalid-credential':
            print('Error: Credenciales inválidas');
            break;

          default:
            print('Error: ${e.message}');
        }
      } else {
        print("Error al actualizar la contraseña: ${e}");
      }
    }
  }
}
