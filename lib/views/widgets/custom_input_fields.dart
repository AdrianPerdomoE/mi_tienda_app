import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regex;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  const CustomTextFormField({
    super.key,
    required this.onSaved,
    required this.regex,
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
      validator: (value) =>
          RegExp(regex).hasMatch(value!) ? null : "Ingresa un valor válido",
    );
  }
}

class CustomTextFormFieldPlain extends StatelessWidget {
  final Function(String) onSaved;
  final String regex;
  final int? maxLines;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  const CustomTextFormFieldPlain({
    super.key,
    required this.onSaved,
    required this.regex,
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
      validator: (value) =>
          RegExp(regex).hasMatch(value!) ? null : "Ingresa un valor válido",
    );
  }
}
