import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:provider/provider.dart';

import '../../global/input_regex_validation.dart';

class CustomTextFormField extends StatefulWidget {
  // Class que define un campo de texto personalizado
  final Function(String)
      onSaved; // Funcion que se ejecuta cuando se guarda el campo
  final StringOrNullFunction validator; // Funcion que valida el campo
  final String hintText; // Texto que se muestra como pista
  final bool obscureText; // Indica si el texto es visible o no
  final TextInputType? keyboardType; // Tipo de teclado
  final int? maxLines;

  const CustomTextFormField({
    super.key,
    required this.onSaved,
    required this.validator,
    required this.hintText,
    required this.obscureText,
    this.keyboardType,
    this.maxLines,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  // Numero maximo de lineas
  late AppDataProvider appDataProvider;

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    return TextFormField(
      cursorColor: appDataProvider.accentColor,
      onSaved: (value) => widget.onSaved(value!),
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey[700]),
        fillColor: appDataProvider.backgroundColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: appDataProvider.accentColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: appDataProvider.primaryColor,
          ),
        ),
      ),
      validator: (value) => widget.validator(value!),
    );
  }
}

class CustomTextFormFieldPlain extends StatelessWidget {
  // Clase que define un campo de texto personalizado sin estilo
  final Function(String) onSaved;
  final StringOrNullFunction validator;
  final int? maxLines;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  const CustomTextFormFieldPlain({
    super.key,
    required this.onSaved,
    required this.validator,
    required this.hintText,
    required this.obscureText,
    this.keyboardType,
    this.maxLines,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => onSaved(value!),
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) => validator(value!),
    );
  }
}
