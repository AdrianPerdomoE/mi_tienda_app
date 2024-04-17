import 'package:flutter/material.dart';
//
import '../../widgets/custom_input_fields.dart';

class UpdateCredentialsDialog extends StatefulWidget {
  final String title;
  final String label;
  final Function({required String newValue}) onUpdate;
  final bool confirmationRequired;
  final bool obscureText;
  final String regex;
  const UpdateCredentialsDialog(
      {super.key,
      required this.title,
      required this.label,
      required this.confirmationRequired,
      required this.onUpdate,
      required this.regex,
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
              formKey.currentState!.save();
              if (widget.confirmationRequired &&
                  newValue != confirmationValue) {
                print('Los valores no coinciden');
                return;
              }
              widget.onUpdate(newValue: newValue);
              Navigator.of(context).pop();
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
                regex: widget.regex,
                hintText: widget.label,
                obscureText: widget.obscureText),
            if (widget.confirmationRequired)
              CustomTextFormField(
                  onSaved: (value) {
                    confirmationValue = value;
                  },
                  regex: widget.regex,
                  hintText: 'Confirmar ${widget.label.toLowerCase()}',
                  obscureText: widget.obscureText),
          ],
        ),
      ),
    );
  }
}
