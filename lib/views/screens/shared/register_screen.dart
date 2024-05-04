//packages
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/services/notification_service.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';
import 'package:mi_tienda_app/global/placeholder_images_urls.dart';

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
  late AppDataProvider _appDataProvider;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _databaseService = GetIt.instance.get<UserDatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _notificationService = NotificationService();
    _appDataProvider = context.watch<AppDataProvider>();

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      backgroundColor: _appDataProvider.secondaryColor,
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
      imagePath: PlaceholderImagesUrls.png150Image,
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
                  validator: InputRegexValidator.validateName,
                  hintText: "Nombre",
                  obscureText: false),
              CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: InputRegexValidator.validateEmail,
                  hintText: "Correo electrónico",
                  obscureText: false),
              CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                  validator: InputRegexValidator.validateAddress,
                  hintText: "Dirección",
                  obscureText: false),
              CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: InputRegexValidator.validatePassword,
                  maxLines: 1,
                  hintText: "Contraseña",
                  obscureText: true),
              _registerButton(),
              _registerAccountLink(),
            ],
          )),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: 'Registrarse',
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
            _notificationService.showNotificationBottom(context,
                'Hubo un error al registrar la imagen', NotificationType.error);
            imageUrl = "";
          }
          _databaseService.createCustomer(
              uid, name!, email!, imageUrl, address!);
          _notificationService.showNotificationBottom(context,
              'Usuario registrado correctamente', NotificationType.success);
          _navigationService.removeAndNavigateToRoute('/login');
        }
      },
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () {
        _navigationService.goBack();
      },
      child: Text(
        "¿Ya tienes una cuenta? ¡Inicia sesión aquí!",
        style: TextStyle(
          color: _appDataProvider.textColor,
          decoration: TextDecoration.underline,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
