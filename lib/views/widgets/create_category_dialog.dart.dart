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
  int categoryOrder = 0;

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
              _categoriesDatabaseService.add(categoryName, categoryOrder);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Agregar'),
        ),
      ],
      title: const Text('Agregar categoría'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormFieldPlain(
              onSaved: (value) => categoryName = value,
              hintText: "Nombre de la categoría",
              validator: InputRegexValidator.validateName,
              obscureText: false,
              maxLines: 1,
            ),
            CustomTextFormFieldPlain(
              onSaved: (value) => categoryOrder = int.parse(value),
              hintText: "Orden de la categoría",
              validator: InputRegexValidator.validateNumber,
              obscureText: false,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
