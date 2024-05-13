import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/products_provider.dart';
import 'package:mi_tienda_app/controllers/services/categories_database_service.dart';
import 'package:mi_tienda_app/controllers/services/products_database_service.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';
import 'package:mi_tienda_app/global/placeholder_images_urls.dart';

import 'package:mi_tienda_app/models/category.dart';
import 'package:provider/provider.dart';

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
  final CategoriesDatabaseService _categoriesDatabaseService =
      GetIt.instance.get<CategoriesDatabaseService>();
  PlatformFile? _image;
  final _formKey = GlobalKey<FormState>();
  late ProductsProvider productsProvider;

  String name = '';
  String description = '';
  double price = 0;
  double discount = 0;
  int stock = 0;

  Category? currentcategory;
  @override
  Widget build(BuildContext context) {
    productsProvider = context.watch<ProductsProvider>();

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
                  .add(name, description, _image!, price, currentcategory!.id,
                      stock, discount)
                  .then((value) {
                Navigator.of(context).pop();
                productsProvider.getProducts();
              });
            }
          },
          child: const Text('Agregar'),
        ),
      ],
      title: const Text('Agregar Producto'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          height: 500,
          width: 600,
          child: ListView(
            children: [
              _imageField(),
              TextFormField(
                //Campo de nombre
                decoration: const InputDecoration(
                  hintText: 'Nombre del producto',
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                onSaved: (newValue) => name = newValue!,
                validator: (value) =>
                    InputRegexValidator.validateTextArea(value!),
              ),
              TextFormField(
                //campo de descripcion
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.production_quantity_limits_sharp),
                  hintText: 'Descripción',
                ),
                onSaved: (newValue) => description = newValue!,
                validator: (value) =>
                    InputRegexValidator.validateTextArea(value!),
              ),
              TextFormField(
                //campó de precio
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: 'Precio',
                ),
                onSaved: (newValue) => price = double.parse(newValue!),
                validator: (value) =>
                    InputRegexValidator.validateAmount(value!),
              ),
              TextFormField(
                //campo de descuento
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.money_off),
                  hintText: 'Descuento',
                ),
                onSaved: (newValue) => discount = double.parse(newValue!),
                validator: (value) =>
                    InputRegexValidator.validateDiscount(value!),
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
              FutureBuilder(
                future: _categoriesDatabaseService.getCategories(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.active || ConnectionState.done:
                      if (!snapshot.hasData) {
                        return const Text('No hay datos');
                      }
                      if (snapshot.hasError) {
                        return const Text('Error');
                      }
                      final categories = snapshot.data as List<Category>;
                      if (categories.isEmpty) {
                        return const Text('No hay categorías');
                      }
                      return DropdownButtonFormField<Category>(
                        menuMaxHeight: 300,
                        borderRadius: BorderRadius.circular(10),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.category),
                          hintText: 'Categoría',
                        ),
                        value: currentcategory,
                        onChanged: (newValue) {
                          setState(() {
                            currentcategory = newValue;
                          });
                        },
                        items: _buildCategoryDropdownItems(categories),
                        validator: (value) {
                          if (value == null) {
                            return 'Seleccione una categoría';
                          }
                          return null;
                        },
                      );

                    case ConnectionState.none:
                      return const Text('No hay conexión');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<Category>> _buildCategoryDropdownItems(
      List<Category> categories) {
    return categories.map((category) {
      return DropdownMenuItem<Category>(
        alignment: Alignment.center,
        value: category,
        child: Text(
          category.name,
        ),
      );
    }).toList();
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
