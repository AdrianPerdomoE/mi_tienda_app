import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/distributor_database_service.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/app__data_provider.dart';
import '../../models/comment.dart';
import 'confirm_delete_element_dialog.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final Function onDelete;
  final Function upDate;
  const CommentWidget(
      {super.key,
      required this.comment,
      required this.onDelete,
      required this.upDate});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late AppDataProvider _appDataProvider;

  bool _isEditing = false;

  final TextEditingController _commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _appDataProvider = context.watch<AppDataProvider>();
    _commentController.text = widget.comment.content;
    return Card(
        color: _appDataProvider.accentColor.withOpacity(0.6),
        child: ListTile(
            dense: true,
            title: Text(
                "${widget.comment.creator} ${formatDate(widget.comment.creationDate)}",
                style: const TextStyle(fontSize: 13)),
            subtitle: Form(
              key: formKey,
              child: TextFormField(
                controller: _commentController,
                enabled: _isEditing,
                validator: (value) =>
                    InputRegexValidator.validateTextArea(value!),
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Comentario",
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(_isEditing ? Icons.save : Icons.edit,
                      color: Colors.white),
                  onPressed: () {
                    if (_isEditing) {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          _isEditing = !_isEditing;
                          widget.comment.content = _commentController.text;
                          widget.comment.creationDate = DateTime.now();
                          widget.upDate();
                        });
                      }
                    } else {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[800],
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ConfirmDeleteElementDialog(
                            content:
                                "¿Estas seguro que desea eliminar el comentario?",
                            onDelete: widget.onDelete);
                      },
                    );
                  },
                )
              ],
            )));
  }
}

String formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}
