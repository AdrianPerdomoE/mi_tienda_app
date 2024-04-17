import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/providers/authentication_provider.dart';
import '../../../models/store_user.dart';

Future<bool> reAuthenticateWithPassword(BuildContext context) async {
  final auth = context.read<AuthenticationProvider>();
  IUser user = auth.user;
  TextEditingController passwordController = TextEditingController();
  String? password;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Autenticación requerida'),
        content: SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                obscureText: false,
                enabled: false,
                decoration: InputDecoration(
                  hintText: user.email,
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Ingresa tu contraseña',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Autenticar'),
            onPressed: () {
              password = passwordController.text;
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  if (password == null) return false;
  return await auth.reauthenticateWithPassword(password!);
}
