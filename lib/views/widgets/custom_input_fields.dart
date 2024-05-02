import 'package:flutter/material.dart';

import '../../global/input_regex_validation.dart';

class CustomTextFormField extends StatelessWidget {
  // Class que define un campo de texto personalizado
  final Function(String)
      onSaved; // Funcion que se ejecuta cuando se guarda el campo
  final StringOrNullFunction validator; // Funcion que valida el campo
  final String hintText; // Texto que se muestra como pista
  final bool obscureText; // Indica si el texto es visible o no
  final TextInputType? keyboardType; // Tipo de teclado
  final int? maxLines; // Numero maximo de lineas
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
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => onSaved(value!),
      cursorColor: Colors.white,
      keyboardType: keyboardType ?? TextInputType.text,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        fillColor: const Color.fromRGBO(30, 29, 37, 1),
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
      validator: (value) => validator(value!),
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
