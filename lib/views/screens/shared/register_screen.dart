//packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

//services
import '../../../controllers/services/navigation_service.dart';
import '../../../controllers/services/cloud_storage_service.dart';
import '../../../controllers/services/media_service.dart';
import '../../../controllers/services/user_database_service.dart';

//widgets
import '../../widgets/custom_input_fields.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/rounded_image.dart';
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
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _databaseService = GetIt.instance<UserDatabaseService>();
    _cloudStorageService = GetIt.instance<CloudStorageService>();
    _navigationService = GetIt.instance<NavigationService>();

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, //No se cambia el tamaño de la pantalla cuando aparece el teclado
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
            _profileImageField(),
            _registerForm(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _registerButton()
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      child: _imageWidget(),
      onTap: () => {
        GetIt.instance<MediaService>()
            .pickImageFromLibrary()
            .then((PlatformFile? image) {
          if (image != null) {
            setState(() {
              _image = image;
            });
          }
        })
      },
    );
  }

  Widget _imageWidget() {
    if (_image != null) {
      return RoundedImageFile(
        file: _image!,
        imageSize: _deviceHeight * 0.15,
      );
    }
    return RoundedImageNetwork(
      imagePath: 'https://picsum.photos/250?image=9',
      imageSize: _deviceHeight * 0.15,
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.40,
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
                  hintText: "Contraseña",
                  obscureText: true),
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
              _showMessage('Please select a profile image.');
              return;
            }
            formKey.currentState!.save();
            String? uid =
                await _authenticationProvider.registerUsingEmailAndPassword(
                    email: email!, password: password!);
            if (uid == null) {
              _showMessage('Hubo un error al registrar el usuario');
              return;
            }
            String? imageUrl =
                await _cloudStorageService.saveUserImageToStorage(uid, _image!);
            if (imageUrl == null) {
              _showMessage('Hubo un error al registrar la imagen');
              imageUrl = "";
            }
            _databaseService.createCustomer(
                uid, name!, email!, imageUrl, address!);
            print('Usuario registrado');
            Future.delayed(const Duration(seconds: 1), () {
              _navigationService.removeAndNavigateToRoute('/login');
            });
          }
        });
  }

  _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
