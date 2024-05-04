import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/products_database_service.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';
import 'package:mi_tienda_app/global/placeholder_images_urls.dart';
import 'package:mi_tienda_app/models/category.dart';
import 'package:mi_tienda_app/views/widgets/custom_input_fields.dart';
//Widgets
import 'editable_image_field.dart';

class CreateProductDialog extends StatefulWidget {
  const CreateProductDialog({super.key});

  @override
  State<CreateProductDialog> createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  final ProductsDatabaseService _productsDatabaseService =
      GetIt.instance.get<ProductsDatabaseService>();
  PlatformFile? _image;
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  double price = 0;
  double discount = 0;
  int stock = 0;

  Category? category;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && _image != null) {
              _formKey.currentState!.save();
              _productsDatabaseService
                  .add(name, description, _image!, price, category!.id, stock,
                      discount)
                  .then((value) => Navigator.of(context).pop());
            }
          },
          child: const Text('Agregar'),
        ),
      ],
      title: const Text('Agregar Producto'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          height: 400,
          width: 600,
          child: ListView(
            children: [
              _imageField(),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Nombre del producto',
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                onSaved: (newValue) {
                  name = newValue!;
                },
                validator: (value) => InputRegexValidator.validateName(name),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.production_quantity_limits_sharp),
                  hintText: 'Descripción',
                ),
                onSaved: (newValue) => description = newValue!,
                validator: (value) =>
                    InputRegexValidator.validateTextArea(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: 'Precio',
                ),
                onSaved: (newValue) => price = double.parse(newValue!),
                validator: (value) =>
                    InputRegexValidator.validateAmount(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.money_off),
                  hintText: 'Descuento',
                ),
                onSaved: (newValue) => discount = double.parse(newValue!),
                validator: (value) =>
                    InputRegexValidator.validateAmount(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.inventory),
                  hintText: 'Stock',
                ),
                onSaved: (newValue) => stock = int.parse(newValue!),
                validator: (value) =>
                    InputRegexValidator.validateAmount(value!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageField() {
    return EditableImageField(
      imagePath: PlaceholderImagesUrls.png150Image,
      image: _image,
      setImageFile: (image) {
        setState(() {
          _image = image;
        });
      },
    );
  }
}
