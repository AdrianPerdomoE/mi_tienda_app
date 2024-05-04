import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:mi_tienda_app/controllers/services/categories_database_service.dart";
import "package:mi_tienda_app/global/input_regex_validation.dart";
import "package:mi_tienda_app/views/widgets/custom_input_fields.dart";

class CreateCategoryDialog extends StatefulWidget {
  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  final CategoriesDatabaseService _categoriesDatabaseService =
      GetIt.instance.get<CategoriesDatabaseService>();

  final _formKey = GlobalKey<FormState>();
  String categoryName = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _categoriesDatabaseService.add(categoryName);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Agregar'),
        ),
      ],
      title: const Text('Agregar Categoría'),
      content: Form(
          key: _formKey,
          child: CustomTextFormFieldPlain(
            hintText: "Nombre de la categoría",
            obscureText: false,
            validator: InputRegexValidator.validateName,
            onSaved: (p0) {
              categoryName = p0!;
            },
            maxLines: 1,
          )),
    );
  }
}
