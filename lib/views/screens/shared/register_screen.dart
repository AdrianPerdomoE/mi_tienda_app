//packages
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/notification_service.dart';

import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

//services
import '../../../controllers/services/navigation_service.dart';
import '../../../controllers/services/cloud_storage_service.dart';
import '../../../controllers/services/user_database_service.dart';

//widgets
import '../../widgets/custom_input_fields.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/editable_image_field.dart';

//providers

import '../../../controllers/providers/authentication_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double _deviceHeight;
  late double _deviceWidth;
  final formKey = GlobalKey<FormState>();
  PlatformFile? _image;

  String? email;
  String? name;
  String? password;
  String? address;

  late AuthenticationProvider _authenticationProvider;
  late UserDatabaseService _databaseService;
  late CloudStorageService _cloudStorageService;
  late NavigationService _navigationService;
  late NotificationService _notificationService;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _databaseService = GetIt.instance.get<UserDatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _notificationService = NotificationService();

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, //No se cambia el tamaño de la pantalla cuando aparece el teclado
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
        margin: EdgeInsets.only(top: _deviceHeight * 0.05),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageField(),
            _registerForm(),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return EditableImageField(
      imagePath: 'https://picsum.photos/250?image=9',
      image: _image,
      setImageFile: (image) {
        setState(() {
          _image = image;
        });
      },
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.65,
      margin: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.02, vertical: _deviceHeight * 0.02),
      child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  regex: r'^[a-zA-Z\s]{1,}[\.]{0,1}[a-zA-Z\s]{0,}$',
                  hintText: "Nombre",
                  obscureText: false),
              CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  regex: r'.{8,}',
                  hintText: "Correo Electrónico",
                  obscureText: false),
              CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                  regex: r'.{8,}',
                  hintText: "Dirección",
                  obscureText: false),
              CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  regex: r'.{8,}',
                  maxLines: 1,
                  hintText: "Contraseña",
                  obscureText: true),
              _registerButton()
            ],
          )),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
        name: 'Registrar',
        height: _deviceHeight * 0.065,
        width: _deviceWidth * 0.65,
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            if (_image == null) {
              _notificationService.showNotificationBottom(context,
                  'Por favor selecciona una imagen', NotificationType.warning);
              return;
            }
            formKey.currentState!.save();
            String? uid =
                await _authenticationProvider.registerUsingEmailAndPassword(
                    email: email!, password: password!);
            if (uid == null) {
              _notificationService.showNotificationBottom(
                  context,
                  'Hubo un error al registrar el usuario',
                  NotificationType.error);
              return;
            }
            String? imageUrl =
                await _cloudStorageService.saveUserImageToStorage(uid, _image!);
            if (imageUrl == null) {
              _notificationService.showNotificationBottom(
                  context,
                  'Hubo un error al registrar la imagen',
                  NotificationType.error);
              imageUrl = "";
            }
            _databaseService.createCustomer(
                uid, name!, email!, imageUrl, address!);
            _notificationService.showNotificationBottom(context,
                'Usuario registrado correctamente', NotificationType.success);
            _navigationService.removeAndNavigateToRoute('/login');
          }
        });
  }
}
