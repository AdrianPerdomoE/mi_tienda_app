import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';
//
import '../../../controllers/services/notification_service.dart';
import '../../widgets/custom_input_fields.dart';

class UpdateCredentialsDialog extends StatefulWidget {
  // clase que define un dialogo para actualizar credenciales
  final String title; // Titulo del dialogo
  final String label; // Etiqueta del campo a actualizar
  final Function({required String newValue})
      onUpdate; // Funcion que se ejecuta al actualizar
  final bool confirmationRequired; // Indica si se requiere confirmacion
  final bool obscureText; // Indica si el texto es visible o no
  final StringOrNullFunction validator; // Funcion que valida el texto ingresado
  const UpdateCredentialsDialog(
      {super.key,
      required this.title,
      required this.label,
      required this.confirmationRequired,
      required this.onUpdate,
      required this.validator,
      required this.obscureText});

  @override
  State<UpdateCredentialsDialog> createState() =>
      _UpdateCredentialsDialogState();
}

class _UpdateCredentialsDialogState extends State<UpdateCredentialsDialog> {
  String newValue = '';
  String confirmationValue = '';

  late double _height;
  late double _width;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Text(widget.title),
      content: _buildForm(),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              // Si el formulario es valido
              formKey.currentState!
                  .save(); // Se guarda el estado del formulario
              if (widget
                      .confirmationRequired && // Si se requiere confirmacion y los valores no coinciden
                  newValue != confirmationValue) {
                GetIt.instance
                    .get<NotificationService>()
                    .showNotificationBottom(
                        context,
                        'Los valores no coinciden',
                        NotificationType
                            .error); // Se muestra una notificacion de error
                return;
              }
              widget.onUpdate(
                  newValue: newValue); // Se ejecuta la funcion de actualizacion
              Navigator.of(context).pop(); // Se cierra el dialogo
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return SizedBox(
      height: _height * 0.5,
      width: _width,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomTextFormField(
                onSaved: (value) {
                  newValue = value;
                },
                validator: widget.validator,
                hintText: widget.label,
                obscureText: widget.obscureText),
            if (widget.confirmationRequired)
              CustomTextFormField(
                  onSaved: (value) {
                    confirmationValue = value;
                  },
                  validator: widget.validator,
                  hintText: 'Confirmar ${widget.label.toLowerCase()}',
                  obscureText: widget.obscureText),
          ],
        ),
      ),
    );
  }
}
