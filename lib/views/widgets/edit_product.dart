import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
//Widgets
import 'package:mi_tienda_app/views/widgets/editable_image_field.dart';
import 'package:mi_tienda_app/views/widgets/editable_image_field.dart';
//Models
import 'package:mi_tienda_app/models/product.dart';

class EditProduct extends  StatefulWidget{
  final Product product;
  EditProduct({required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  PlatformFile? _image;
  Product product = Product(
    name: '',
    id: '', 
    description: '', 
    imageUrl: '', 
    price: 0, 
    categoryId: '', 
    creationDate: DateTime.now(), 
    hidden: false, 
    stock: 0, 
    discount: 0
  );

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _categoryIdController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  
  @override
  void initState(){
    super.initState();
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _categoryIdController.text = product.categoryId;
    _stockController.text = product.stock.toString();
    _discountController.text = product.discount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _ImageField(),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Precio'),
            ),
            TextFormField(
              controller: _categoryIdController,
              decoration: InputDecoration(labelText: 'Categoría'),
            ),
            TextFormField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Stock'),
            ),
            TextFormField(
              controller: _discountController,
              decoration: InputDecoration(labelText: 'Descuento'),
            ),
            ElevatedButton(onPressed: () {
              setState(() {
                product.name = _nameController.text;
                product.description = _descriptionController.text;
                product.price = double.parse(_priceController.text);
                product.categoryId = _categoryIdController.text;
                product.stock = int.parse(_stockController.text);
                product.discount = double.parse(_discountController.text);
              });
              Navigator.pop(context, product);
            },child:
              Text('Actualizar producto'),
            ),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: 
              Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ImageField() {
    return EditableImageField(
      imagePath: 'https://picsum.photos/250?image=9',
      image: _image,
      setImageFile: (image) {
        setState(() {
          _image = image;
        });
      },
    );
  }
}