import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/loading_provider.dart';
import '../../controllers/services/distributor_database_service.dart';
import '../../global/input_regex_validation.dart';
import '../../models/comment.dart';
import '../../models/distributor.dart';
import 'custom_input_fields.dart';

class AddCommentDialog extends StatefulWidget {
  final Distributor distributor;
  final Function addComment;
  const AddCommentDialog(
      {super.key, required this.distributor, required this.addComment});

  @override
  State<AddCommentDialog> createState() => _AddCommentDialogState();
}

class _AddCommentDialogState extends State<AddCommentDialog> {
  final DistributorDatabaseService _distributorDatabaseService =
      GetIt.instance.get<DistributorDatabaseService>();
  String _comment = "";
  final formKey = GlobalKey<FormState>();
  late LoadingProvider _loadingProvider;
  late AuthenticationProvider _authProvider;
  @override
  Widget build(BuildContext context) {
    _loadingProvider = context.watch<LoadingProvider>();
    _authProvider = context.watch<AuthenticationProvider>();
    return AlertDialog(
      title: const Text("Agregar comentario"),
      content: Form(
        key: formKey,
        child: Container(
          margin: const EdgeInsets.all(10),
          width: 700,
          child: CustomTextFormField(
            hintText: "Comentario",
            obscureText: false,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            onSaved: (value) {
              setState(() {
                _comment = value;
              });
            },
            validator: InputRegexValidator.validateTextArea,
          ),
        ),
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
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              _loadingProvider.setLoading(true);
              Comment newComment = Comment(
                  creator: _authProvider.user.name,
                  content: _comment,
                  creationDate: DateTime.now());
              _distributorDatabaseService
                  .addCommentToDistributor(widget.distributor.id, newComment)
                  .then((value) {
                widget.addComment(newComment);
                _loadingProvider.setLoading(false);
                Navigator.of(context).pop();
              });
            }
          },
          child: const Text("Agregar"),
        ),
      ],
    );
  }
}

//TODO Agregar seccion de gestion del comentario para editar, borrar y agregar comentarios

