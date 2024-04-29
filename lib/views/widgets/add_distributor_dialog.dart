import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/loading_provider.dart';
import 'package:mi_tienda_app/controllers/services/distributor_database_service.dart';
import 'package:mi_tienda_app/controllers/services/notification_service.dart';
import 'package:mi_tienda_app/views/widgets/custom_input_fields.dart';
import 'package:mi_tienda_app/views/widgets/editable_image_field.dart';
import 'package:provider/provider.dart';

class AddDistributorDialog extends StatefulWidget {
  AddDistributorDialog({super.key});

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

  DistributorDatabaseService _distributorDatabaseService =
      GetIt.instance.get<DistributorDatabaseService>();
  late LoadingProvider _loadingProvider;
  PlatformFile? _imageFile;
  NotificationService _notificationService =
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
            imagePath: 'https://via.placeholder.com/150',
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
                      regex: r'^[a-zA-Z\s]+$',
                      hintText: "Nombre",
                      obscureText: false),
                  CustomTextFormFieldPlain(
                      onSaved: (value) {
                        _phone = value;
                      },
                      regex: r'^\d{10}$',
                      hintText: "Numero",
                      keyboardType: TextInputType.phone,
                      obscureText: false),
                  CustomTextFormFieldPlain(
                      onSaved: (value) {
                        _email = value;
                      },
                      regex:
                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[\w-]+$', // regex for an email
                      hintText: "Email",
                      obscureText: false),
                  CustomTextFormFieldPlain(
                      onSaved: (value) {
                        _address = value;
                      },
                      regex:
                          r'^(calle|carrera)\s\d+[A-Za-z]?\s#\s\d+[A-Za-z]?\s?[A-Za-z0-9\s]{0,100}$', //regex para una direccion
                      hintText: "Dirección",
                      obscureText: false),
                  CustomTextFormFieldPlain(
                    onSaved: (value) {
                      _description =
                          value; //value is the string of the text field
                    },
                    regex: r'^\w+(\s+\w+)*$',
                    hintText: "Descripcion",
                    obscureText: false,
                    keyboardType: TextInputType.multiline,
                  ),
                  CustomTextFormFieldPlain(
                      onSaved: (value) {
                        _rating = int.parse(value);
                      },
                      regex: r'^[0-5]$',
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
