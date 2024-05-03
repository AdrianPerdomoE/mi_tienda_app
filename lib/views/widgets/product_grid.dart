import 'package:flutter/material.dart';
//models
import 'package:mi_tienda_app/models/product.dart';
//widgets
import 'package:mi_tienda_app/views/widgets/edit_product.dart';

class ProductGrid extends StatefulWidget{
  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  
  List<Product> products = [
    Product(
      name: 'Carne de res',
      id: '1',
      description: 'Carnes',
      imageUrl: 'https://picsum.photos/200/300',
      price: 44200,
      categoryId: '1',
      creationDate: DateTime.now(),
      hidden: false,
      stock: 10,
      discount: 0,
    ),
    Product(
      name: 'Leche descremada',
      id: '2',
      description: 'Lácteos',
      imageUrl: 'https://picsum.photos/200/300',
      price: 44200,
      categoryId: '2',
      creationDate: DateTime.now(),
      hidden: false,
      stock: 10,
      discount: 0,
    ),
    Product(
      name: 'Arroz',
      id: '3',
      description: 'Alimentos',
      imageUrl: 'https://picsum.photos/200/300',
      price: 44200,
      categoryId: '3',
      creationDate: DateTime.now(),
      hidden: false,
      stock: 10,
      discount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 155/ 190,
      ),
      itemCount: products.length,
      itemBuilder:(context, index) {
        final product = products[index];
        return Card(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: ListTile(
                    title: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    subtitle: Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    trailing: Text(
                        product.price.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProduct(product: product),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}