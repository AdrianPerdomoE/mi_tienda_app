import 'package:flutter/material.dart';

class ConfirmDeleteElementDialog extends StatelessWidget {
  // Clase que define un dialogo de confirmacion para eliminar un elemento
  const ConfirmDeleteElementDialog(
      {super.key, required this.content, required this.onDelete});
  final String content; // Contenido del dialogo
  final Function onDelete; // Funcion que se ejecuta al confirmar la eliminacion
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar eliminación'),
      content: Text(content), // Contenido del dialogo
      actions: [
        TextButton(
          onPressed: () {
            // Boton para cancelar la eliminacion
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onDelete(); // Boton para confirmar la eliminacion
            Navigator.of(context).pop();
          },
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
