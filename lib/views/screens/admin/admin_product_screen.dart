import 'package:flutter/material.dart';

//Models
import 'package:mi_tienda_app/models/category.dart';
import 'package:mi_tienda_app/models/product.dart';
//Widgets
import 'package:mi_tienda_app/views/widgets/create_category_dialog.dart.dart';
import 'package:mi_tienda_app/views/widgets/create_product_dialog.dart.dart'; 
import 'package:mi_tienda_app/views/widgets/editable_image_field.dart';
import 'package:mi_tienda_app/views/widgets/product_grid.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  List<String> categories = ['Carnes', 'Lácteos', 'Alimentos'];
  String selectedCategory = 'Carnes';
  String categoryName = '';

  @override
  Widget build(BuildContext context) {
    return _buildUi();
  }

  _buildUi() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 10),
      child: ListView(
        children: [
          _buildSearch(),
          _buildCategory(),
          _buildProductList(),
        ]
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.menu,
              color: Colors.grey,
            ),
            SizedBox(width: 6),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar producto...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  print(value);
                },
              ),
            ),
            Icon(Icons.search, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Agregar Categoría', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _buildShowCategoryPopup(context);
                },
                child: Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 13,
                  ),
                  minimumSize: Size(35, 24),
                ),
                
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _categoryButton(
                label: 'Carnes',
              ),
              _categoryButton(
                label: 'Lácteos',
              ),
              _categoryButton(
                label: 'Alimentos',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryButton({required String label}) {
    return InkWell(
      onTap: () {
      
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }

  Widget _buildProductList() {
    return Column(
      children: [
        Row(
          children: [
            Text('Agregar Producto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                _buildShowProductPopup(context);  
              },
              child: Text('Agregar'),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 13,
                ),
                minimumSize: Size(35, 24),
              ),
            ),
          ],
        ),
        _productGrid(),
      ],
    );
  }

  Widget _productGrid() {
    return ProductGrid();
  }

  _buildShowCategoryPopup(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      return CreateCategoryDialog();
    });
  }

  _buildShowProductPopup(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      return CreateProductDialog();
    });
  }

  _addCategory(String category) {
    setState(() {
      categories.add(category);
    });
  }

  _pickedImage () async{
  }


}