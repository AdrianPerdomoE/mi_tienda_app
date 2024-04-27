import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/loading_provider.dart';
import 'package:mi_tienda_app/controllers/services/notification_service.dart';
import 'package:provider/provider.dart';
//Widgets
import '../../widgets/custom_input_fields.dart';
import '../../widgets/rounded_button.dart';
// provider
import '../../../controllers/providers/authentication_provider.dart';
//services
import '../../../controllers/services/navigation_service.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double _deviceHeight;
  late double _deviceWidth;
  final _loginFormKey = GlobalKey<FormState>();
  String? email;
  String? password;
  late AuthenticationProvider _auth;
  late AppDataProvider _appDataProvider;
  late NavigationService _navigationService;
  late NotificationService _notificationService;
  late LoadingProvider _loadingProvider;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = context.watch<AuthenticationProvider>();
    _appDataProvider = context.watch<AppDataProvider>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _loadingProvider = context.watch<LoadingProvider>();
    _notificationService = NotificationService();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _pageTitle(),
              SizedBox(
                height: _deviceHeight * 0.04,
              ),
              _loginForm(),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              _loginButton(),
              SizedBox(
                height: _deviceHeight * 0.02,
              ),
              _registerAccountLink(),
            ]),
      ),
    );
  }

  Widget _pageTitle() {
    return SizedBox(
      height: _deviceHeight * 0.1,
      child: Text(
        _appDataProvider.appName,
        style: TextStyle(
          color: _appDataProvider.textColor,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _loginForm() {
    return SizedBox(
      height: _deviceHeight * 0.25,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
                regex: r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                hintText: "Email",
                obscureText: false),
            CustomTextFormField(
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
                regex: r".{8,}",
                hintText: "Password",
                obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return RoundedButton(
      name: "Login",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () {
        if (_loginFormKey.currentState!.validate()) {
          _loginFormKey.currentState!.save();
          _loadingProvider.setLoading(true);
          _auth
              .loginUsingEmailAndPassword(email: email!, password: password!)
              .then((value) {
            if (value) {
              _notificationService.showNotificationBottom(context,
                  "Inicio de sesión satisfactorio.", NotificationType.success);
            } else {
              _notificationService.showNotificationBottom(context,
                  "No se pudo iniciar sesión.", NotificationType.error);
            }
            _loadingProvider.setLoading(false);
          });
        }
      },
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () {
        _navigationService.navigateToRoute('/register');
      },
      child: Text(
        "Don't have an account? Register here!",
        style: TextStyle(
          color: _appDataProvider.accentColor,
        ),
      ),
    );
  }
}
