import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class LogGoogleButton extends StatelessWidget {
  final double height;
  final double width;

  const LogGoogleButton({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    AppDataProvider appDataProvider = context.watch<AppDataProvider>();
    AuthenticationProvider auth = context.watch<AuthenticationProvider>();
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: appDataProvider.primaryColor,
          borderRadius: BorderRadius.circular(height * 0.25),
          boxShadow: [
            BoxShadow(
              color: appDataProvider.textColor.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: TextButton(
          onPressed: () {
            auth.logWithGoogle();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/google_logo.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 10),
              const Text(
                'Google',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
