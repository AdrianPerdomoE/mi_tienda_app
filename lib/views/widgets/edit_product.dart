import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/loading_provider.dart';
import 'package:mi_tienda_app/controllers/services/categories_database_service.dart';
import 'package:mi_tienda_app/controllers/services/products_database_service.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';
//Widgets
import 'package:mi_tienda_app/views/widgets/editable_image_field.dart';
//Models
import 'package:mi_tienda_app/models/product.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';

class EditProduct extends StatefulWidget {
  final Product product;
  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  PlatformFile? _image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final CategoriesDatabaseService _categoriesDatabaseService =
      GetIt.instance.get<CategoriesDatabaseService>();
  Category? currentcategory;
  final ProductsDatabaseService _productsDatabaseService =
      GetIt.instance.get<ProductsDatabaseService>();
  late LoadingProvider _loadingProvider;
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _descriptionController.text = widget.product.description;
    _priceController.text = widget.product.price.toString();
    _categoryIdController.text = widget.product.categoryId;
    _stockController.text = widget.product.stock.toString();
    _discountController.text = widget.product.discount.toString();
  }

  @override
  Widget build(BuildContext context) {
    _loadingProvider = context.watch<LoadingProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _imageField(),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) =>
                          InputRegexValidator.validateName(value!),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      validator: (value) =>
                          InputRegexValidator.validateTextArea(value!),
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                    ),
                    TextFormField(
                      controller: _priceController,
                      validator: (value) =>
                          InputRegexValidator.validateAmount(value!),
                      decoration: const InputDecoration(labelText: 'Precio'),
                    ),
                    TextFormField(
                      controller: _stockController,
                      validator: (value) =>
                          InputRegexValidator.validateAmount(value!),
                      decoration: const InputDecoration(labelText: 'Stock'),
                    ),
                    TextFormField(
                      controller: _discountController,
                      validator: (value) =>
                          InputRegexValidator.validateDiscount(value!),
                      decoration: const InputDecoration(labelText: 'Descuento'),
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
                            currentcategory = categories.firstWhere((element) =>
                                element.id == widget.product.categoryId);
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
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.product.name = _nameController.text;
                  widget.product.description = _descriptionController.text;
                  widget.product.price = double.parse(_priceController.text);
                  widget.product.categoryId = _categoryIdController.text;
                  widget.product.stock = int.parse(_stockController.text);
                  widget.product.discount =
                      double.parse(_discountController.text);
                  _loadingProvider.setLoading(true);
                  _productsDatabaseService
                      .update(widget.product, _image)
                      .then((value) {
                    _loadingProvider.setLoading(false);
                    Navigator.pop(context);
                  });
                });
              },
              child: const Text('Actualizar producto'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
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
    return EditableImageRectangleField(
      size: 90,
      imagePath: widget.product.imageUrl,
      image: _image,
      setImageFile: (image) {
        setState(() {
          _image = image;
        });
      },
    );
  }
}
