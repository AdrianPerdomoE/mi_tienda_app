import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/cloud_storage_service.dart';
import 'package:mi_tienda_app/views/widgets/editable_image_field.dart';
import 'package:mi_tienda_app/views/widgets/section_togglable_field.dart';

import '../../../controllers/services/distributor_database_service.dart';
import '../../../models/distributor.dart';
import '../../widgets/stlyed_elevated_button.dart';

class DistributorInfoScreen extends StatefulWidget {
  final Distributor distributor;
  const DistributorInfoScreen({super.key, required this.distributor});

  @override
  State<DistributorInfoScreen> createState() => _DistributorInfoScreenState();
}

class _DistributorInfoScreenState extends State<DistributorInfoScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _description = TextEditingController();

  bool _editigPersonalData = false;
  bool _editigContactData = false;

  final CloudStorageService _cloudStorageService =
      GetIt.instance.get<CloudStorageService>();
  final DistributorDatabaseService _distributorDatabaseService =
      GetIt.instance.get<DistributorDatabaseService>();
  PlatformFile? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informacion del distribuidor"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              _buildProfileImage(),
              _buildPersonalDataSection(),
              _buildContactDataSection()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Column(
      children: [
        EditableImageField(
          imagePath: widget.distributor.imageUrl,
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
              String? newImageUrl =
                  await _cloudStorageService.saveDistributorImageToStorage(
                      widget.distributor.id, _image!);
              if (newImageUrl != null) {
                widget.distributor.imageUrl = newImageUrl;
                await _distributorDatabaseService
                    .updateDistributor(widget.distributor);
                setState(() {
                  _image = null;
                });
              }
            },
          )
      ],
    );
  }

  Widget _buildPersonalDataSection() {
    return Section(
      title: "Datos personales",
      isEditing: _editigPersonalData,
      onPressed: () {
        setState(() {
          _editigPersonalData = !_editigPersonalData;
        });
      },
      update: () async {
        setState(() {
          widget.distributor.name = _name.text;
          widget.distributor.description = _description.text;
        });
        await _distributorDatabaseService.updateDistributor(widget.distributor);
      },
      children: [
        TogglableField(
            label: "Nombre",
            value: widget.distributor.name,
            icon: Icons.person,
            controller: _name,
            isEditing: _editigPersonalData),
        TogglableField(
          label: "Descripcion",
          value: widget.distributor.description,
          icon: Icons.description,
          controller: _description,
          isEditing: _editigPersonalData,
        ),
      ],
    );
  }

  _buildContactDataSection() {
    return Section(
      title: "Datos de contacto",
      isEditing: _editigContactData,
      onPressed: () {
        setState(() {
          _editigContactData = !_editigContactData;
        });
      },
      update: () async {
        setState(() {
          widget.distributor.email = _email.text;
          widget.distributor.number = _number.text;
          widget.distributor.address = _address.text;
        });
        await _distributorDatabaseService.updateDistributor(widget.distributor);
      },
      children: [
        TogglableField(
          label: "Email",
          value: widget.distributor.email,
          icon: Icons.email,
          controller: _email,
          isEditing: _editigContactData,
        ),
        TogglableField(
          label: "Numero",
          value: widget.distributor.number,
          icon: Icons.phone,
          controller: _number,
          isEditing: _editigContactData,
        ),
        TogglableField(
          label: "Direccion",
          value: widget.distributor.address,
          icon: Icons.house,
          controller: _address,
          isEditing: _editigContactData,
        ),
      ],
    );
  }
}

//TODO Agregar seccion de gestion del comentario para editar, borrar y agregar comentarios
//TODO standarizar los regex de validacion de los campos de texto
//TODO agregar propiedad de regex para validar el campo antes de guardar el cambio en los TogglableField
//TODO Standarizar la imagen de placeholder para las imagenes sin valor y corregir error del etitableImageField