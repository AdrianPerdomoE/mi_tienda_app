import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mi_tienda_app/controllers/services/cloud_storage_service.dart';
import 'package:mi_tienda_app/controllers/services/notification_service.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';

import 'package:mi_tienda_app/views/widgets/editable_image_field.dart';
import 'package:mi_tienda_app/views/widgets/section_add_button.dart';
import 'package:mi_tienda_app/views/widgets/section_togglable_field.dart';
import 'package:mi_tienda_app/views/widgets/star_list_generator.dart';

import '../../../controllers/services/distributor_database_service.dart';
import '../../../models/distributor.dart';
import '../../widgets/add_comment_dialog.dart';
import '../../widgets/comment_widget.dart';
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
  final TextEditingController _rating = TextEditingController();
  bool _editigPersonalData = false;
  bool _editigContactData = false;
  bool _editigRating = false;
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
              _buildRating(),
              _buildPersonalDataSection(),
              _buildContactDataSection(),
              _buildCommentsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRating() {
    _rating.text = widget.distributor.rating.toString();
    return Section(
      title: "Calificación",
      isEditing: _editigRating,
      onPressed: () {
        setState(() {
          _editigRating = !_editigRating;
        });
      },
      update: () async {
        setState(() {
          widget.distributor.rating = int.parse(_rating.text);
        });
        await _distributorDatabaseService.updateDistributor(widget.distributor);
      },
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            controller: _rating,
            enabled: _editigRating,
            keyboardType: TextInputType.number,
            validator: (value) => InputRegexValidator.validateRating(value!),
            decoration: const InputDecoration(
                icon: Icon(Icons.star, size: 20, color: Colors.amber)),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: starListGenerator(5, widget.distributor.rating, 30),
        )
      ],
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
            validator: InputRegexValidator.validateName,
            label: "Nombre",
            value: widget.distributor.name,
            icon: Icons.person,
            controller: _name,
            isEditing: _editigPersonalData),
        TogglableField(
          validator: InputRegexValidator.validateTextArea,
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
          validator: InputRegexValidator.validateEmail,
          label: "Email",
          value: widget.distributor.email,
          icon: Icons.email,
          controller: _email,
          isEditing: _editigContactData,
        ),
        TogglableField(
          validator: InputRegexValidator.validatePhone,
          label: "Numero",
          value: widget.distributor.number,
          icon: Icons.phone,
          controller: _number,
          isEditing: _editigContactData,
        ),
        TogglableField(
          validator: InputRegexValidator.validateAddress,
          label: "Direccion",
          value: widget.distributor.address,
          icon: Icons.house,
          controller: _address,
          isEditing: _editigContactData,
        ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return SectionAddButton(
      title: "Comentarios",
      onAdd: () {
        showDialog(
            context: context,
            builder: (context) {
              return AddCommentDialog(
                addComment: (comment) {
                  setState(() {
                    widget.distributor.comments.add(comment);
                  });
                },
                distributor: widget.distributor,
              );
            });
      },
      children: _buildComments(),
    );
  }

  List<Widget> _buildComments() {
    if (widget.distributor.comments.isEmpty) {
      return [const Text("No hay comentarios")];
    }
    return widget.distributor.comments
        .map((comment) => CommentWidget(
              upDate: () {
                _distributorDatabaseService
                    .updateDistributor(widget.distributor)
                    .then((value) {
                  if (!value) {
                    GetIt.instance
                        .get<NotificationService>()
                        .showNotificationBottom(
                            context,
                            "Error al actualizar el comentario",
                            NotificationType.error);
                    return null;
                  }
                  GetIt.instance
                      .get<NotificationService>()
                      .showNotificationBottom(context, "Comentario actualizado",
                          NotificationType.success);
                });
              },
              comment: comment,
              onDelete: () {
                setState(() {
                  widget.distributor.comments.remove(comment);
                });
              },
            ))
        .toList();
  }
}
