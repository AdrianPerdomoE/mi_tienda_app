import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';

import 'package:mi_tienda_app/models/store_user.dart';
import 'package:provider/provider.dart';

//services
import '../../../controllers/services/cloud_storage_service.dart';
import '../../../controllers/services/user_database_service.dart';
//providers
import '../../../controllers/providers/authentication_provider.dart';
//widgets
import '../../widgets/editable_image_field.dart';
import '../../widgets/stlyed_elevated_button.dart';
import '../../widgets/section_togglable_field.dart';
import '../shared/update_credentials_dialog.dart';
import '../shared/re_authenticate_with_password.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  late UserDatabaseService _userDatabaseService;
  late AuthenticationProvider _authProvider;
  late CloudStorageService _cloudStorageService;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController maxAmountController = TextEditingController();

  PlatformFile? _image;

  bool isEditingPersonalData = false;
  bool isEditingContactInfo = false;
  bool isEditingShippingInfo = false;
  bool isEditingCreditInfo = false;
  @override
  Widget build(BuildContext context) {
    _userDatabaseService = GetIt.instance.get<UserDatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _authProvider = context.read<AuthenticationProvider>();

    return StreamBuilder(
      stream: _userDatabaseService.getStreamUser(_authProvider.user.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return _buildUi(snapshot.data as Customer);
      },
    );
  }

  _buildUi(Customer customer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 10),
      child: ListView(
        children: [
          _buildProfileImage(customer),
          _buildPersonalDataSection(customer),
          const Divider(),
          _buildContactInfoSection(customer),
          const Divider(),
          _buildShippingInfoSection(customer),
          const Divider(),
          _buildCreditInfo(customer),
          _authProvider.lastSignInProvider == google
              ? const SizedBox(
                  height: 10,
                )
              : _buildUpdateCredentialsButton()
        ],
      ),
    );
  }

  Widget _buildProfileImage(Customer customer) {
    return Column(
      children: [
        EditableImageField(
          imagePath: customer.imageUrl,
          image: _image,
          setImageFile: (image) {
            setState(() {
              _image = image;
            });
          },
        ),
        if (_image != null)
          StyledElevatedButton(
            label: 'Actualizar imagen',
            onPressed: () async {
              String? newImageUrl = await _cloudStorageService
                  .saveUserImageToStorage(customer.id, _image!);
              if (newImageUrl != null) {
                customer.imageUrl = newImageUrl;
                await _userDatabaseService.updateUserData(customer);
                setState(() {
                  _image = null;
                });
              }
            },
          )
      ],
    );
  }

  Widget _buildUpdateCredentialsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StyledElevatedButton(
              label: 'Cambiar contraseña',
              onPressed: () {
                deployUpdatePasswordDialog(context);
              }),
        ],
      ),
    );
  }

  void updateUserData(Customer customer) {
    customer.name = nameController.text;
    customer.address = addressController.text;
    customer.maxCredit = double.parse(maxAmountController.text);
    _userDatabaseService.updateUserData(customer);
  }

  void deployUpdatePasswordDialog(BuildContext context) {
    reAuthenticateWithPassword(context).then((authenticated) {
      if (!authenticated) return;
      showDialog(
        context: context,
        builder: (context) => UpdateCredentialsDialog(
            title: 'Cambiar contraseña',
            obscureText: true,
            validator: InputRegexValidator.validatePassword,
            label: 'Contraseña',
            confirmationRequired: true,
            onUpdate: ({required newValue}) {
              _authProvider.updatePassword(newValue);
            }),
      );
    });
  }

  Widget _buildPersonalDataSection(Customer customer) {
    return Section(
      title: 'Datos Personales',
      update: () {
        updateUserData(customer);
      },
      onPressed: () {
        setState(() {
          isEditingPersonalData = !isEditingPersonalData;
        });
      },
      isEditing: isEditingPersonalData,
      children: [
        TogglableField(
          validator: InputRegexValidator.validateName,
          label: 'Nombre',
          value: customer.name,
          icon: Icons.person_pin,
          controller: nameController,
          isEditing: isEditingPersonalData,
        )
      ],
    );
  }

  Widget _buildShippingInfoSection(Customer customer) {
    return Section(
      title: 'Datos de Envío',
      update: () {
        updateUserData(customer);
      },
      onPressed: () {
        setState(() {
          isEditingShippingInfo = !isEditingShippingInfo;
        });
      },
      isEditing: isEditingShippingInfo,
      children: [
        TogglableField(
          validator: InputRegexValidator.validateAddress,
          label: 'Dirección de residencia',
          value: customer.address,
          icon: Icons.house,
          controller: addressController,
          isEditing: isEditingShippingInfo,
        )
      ],
    );
  }

  Widget _buildContactInfoSection(Customer customer) {
    return Section(
      title: 'Datos de Contacto',
      children: [
        TogglableField(
          validator: InputRegexValidator.validateEmail,
          label: 'Correo electrónico',
          value: customer.email,
          icon: Icons.mail,
          controller: emailController,
        ),
      ],
    );
  }

  Widget _buildCreditInfo(Customer customer) {
    return Section(title: "Datos de credito", children: [
      TogglableField(
        validator: InputRegexValidator.validateAmount,
        label: "Monto maximo a fiar",
        value: customer.maxCredit.toString(),
        icon: Icons.monetization_on_sharp,
        controller: maxAmountController,
      )
    ]);
  }
}
