// packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mi_tienda_app/controllers/services/cart_database_service.dart';
import 'package:mi_tienda_app/global/placeholder_images_urls.dart';
//services
import '../services/user_database_service.dart';
import '../services/navigation_service.dart';
//models
import '../../models/store_user.dart';

const String google = 'google.com';
const String email = 'password';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final UserDatabaseService _databaseService;
  late final NavigationService _navigationService;
  late IUser user;

  String? lastSignInProvider;
  final List<String> scopes = <String>[
    'email',
  ];

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<UserDatabaseService>();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _databaseService.getUser(user.uid).then((value) {
          if (value != null) {
            String lastSignInProvider = user.providerData.last.providerId;
            if (lastSignInProvider == google) {
              this.lastSignInProvider = google;
            } else {
              this.lastSignInProvider = email;
            }
            this.user = value;

            if (!GetIt.instance.isRegistered<CartDatabaseService>()) {
              GetIt.instance.registerSingleton<CartDatabaseService>(
                  CartDatabaseService(user.uid));
            }

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
  Future<bool> loginUsingEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> registerUsingEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credentials.user!.uid;
    } on FirebaseAuthException {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
      lastSignInProvider = null;
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
      if (GetIt.instance.isRegistered<CartDatabaseService>()) {
        GetIt.instance.unregister<CartDatabaseService>();
      }
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

  Future<bool> logWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: scopes).signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential user = await _auth.signInWithCredential(credential);
      if (user.additionalUserInfo!.isNewUser) {
        String imageUrl =
            user.user!.photoURL ?? PlaceholderImagesUrls.png150Image;
        _databaseService.createCustomer(user.user!.uid, user.user!.displayName!,
            user.user!.email!, imageUrl, "");
        return true;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
