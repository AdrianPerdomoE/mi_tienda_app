import 'package:flutter/material.dart';

class ConfirmDeleteElementDialog extends StatelessWidget {
  const ConfirmDeleteElementDialog(
      {super.key, required this.content, required this.onDelete});
  final String content;
  final Function onDelete;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar eliminación'),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.of(context).pop();
          },
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
