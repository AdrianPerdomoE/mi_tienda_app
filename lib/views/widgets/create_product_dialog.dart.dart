import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
//Widgets
import 'editable_image_field.dart';

class CreateProductDialog extends StatefulWidget{
  @override
  State<CreateProductDialog> createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  PlatformFile? _image;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
        actions: [
                  TextButton(
                    onPressed: () {
                    },
                    child: Text('Agregar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                ],
        title: Text('Agregar Producto'),
        content: 
              Container(

                height: 400,
                child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ImageField(),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.shopping_bag),
                        hintText: 'Nombre del producto',
                      ),
                      onChanged: (value) {
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.production_quantity_limits_sharp),
                        hintText: 'Descripción',
                      ),
                      onChanged: (value) {
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.attach_money),
                        hintText: 'Precio',
                      ),
                      onChanged: (value) {
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.money_off),
                        hintText: 'Descuento',
                      ),
                      onChanged: (value) {
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.inventory),
                        hintText: 'Stock',
                      ),
                      onChanged: (value) {
                      },
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