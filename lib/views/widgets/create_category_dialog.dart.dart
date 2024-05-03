import "package:flutter/material.dart";

class CreateCategoryDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
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
        title: Text('Agregar Categoría'),
        content: 
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Nombre de la categoría',
                ),
                onChanged: (value) {
                },
              ),
             
      );
  }
}