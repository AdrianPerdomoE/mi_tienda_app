import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/loading_provider.dart';
import 'package:mi_tienda_app/controllers/services/distributor_database_service.dart';
import 'package:mi_tienda_app/controllers/services/notification_service.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';
import 'package:mi_tienda_app/global/placeholder_images_urls.dart';
import 'package:mi_tienda_app/views/widgets/custom_input_fields.dart';
import 'package:mi_tienda_app/views/widgets/editable_image_field.dart';
import 'package:provider/provider.dart';

class AddDistributorDialog extends StatefulWidget {
  const AddDistributorDialog({super.key});

  @override
  State<AddDistributorDialog> createState() => _AddDistributorDialogState();
}

class _AddDistributorDialogState extends State<AddDistributorDialog> {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  String _description = '';
  int _rating = 0;

  final DistributorDatabaseService _distributorDatabaseService =
      GetIt.instance.get<DistributorDatabaseService>();
  late LoadingProvider _loadingProvider;
  PlatformFile? _imageFile;
  final NotificationService _notificationService =
      GetIt.instance.get<NotificationService>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _loadingProvider = Provider.of<LoadingProvider>(context);
    return AlertDialog(
      scrollable: true,
      title: const Text("Agregar Distribuidor"),
      content: Column(
        children: [
          EditableImageField(
            imagePath: PlaceholderImagesUrls.png150Image,
            setImageFile: (image) {
              if (image != null) {
                setState(() {
                  _imageFile = image;
                });
              }
            },
            image: _imageFile,
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormFieldPlain(
                      onSaved: (value) {
                        _name = value;
                      },
                      validator: InputRegexValidator.validateName,
                      hintText: "Nombre",
                      obscureText: false),
                  CustomTextFormFieldPlain(
                      onSaved: (value) {
                        _phone = value;
                      },
                      validator: InputRegexValidator.validatePhone,
                      hintText: "Numero",
                      keyboardType: TextInputType.phone,
                      obscureText: false),
                  CustomTextFormFieldPlain(
                      onSaved: (value) {
                        _email = value;
                      },
                      validator: InputRegexValidator
                          .validateEmail, // regex for an email
                      hintText: "Email",
                      obscureText: false),
                  CustomTextFormFieldPlain(
                      onSaved: (value) {
                        _address = value;
                      },
                      validator: InputRegexValidator
                          .validateAddress, //regex para una direccion
                      hintText: "Dirección",
                      obscureText: false),
                  CustomTextFormFieldPlain(
                    onSaved: (value) {
                      _description =
                          value; //value is the string of the text field
                    },
                    validator: InputRegexValidator.validateTextArea,
                    hintText: "Descripcion",
                    obscureText: false,
                    keyboardType: TextInputType.multiline,
                  ),
                  CustomTextFormFieldPlain(
                      onSaved: (value) {
                        _rating = int.parse(value);
                      },
                      validator: InputRegexValidator.validateRating,
                      hintText: "Rating",
                      keyboardType: TextInputType.number,
                      obscureText: false),
                ],
              ))
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _loadingProvider.setLoading(true);
              setState(() {
                _formKey.currentState!.save();
              });
              _distributorDatabaseService
                  .addDistributor(_name, _phone, _email, _address, _description,
                      _imageFile!, _rating)
                  .then((value) {
                _loadingProvider.setLoading(false);
                Navigator.of(context).pop();
                _notificationService.showNotificationBottom(
                    context,
                    "El distribuidor $_name ha sido agregado correctamente",
                    NotificationType.success);
              });
            }
          },
          child: const Text("Agregar"),
        ),
      ],
    );
  }
}
