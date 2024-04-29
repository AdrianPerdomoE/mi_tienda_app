import 'package:flutter/material.dart';
import 'package:mi_tienda_app/models/category.dart';
import 'package:mi_tienda_app/models/product.dart';

class CustomerProductsScreen extends StatefulWidget {
  const CustomerProductsScreen({super.key});

  @override
  State<CustomerProductsScreen> createState() => _CustomerProductsScreenState();
}

class _CustomerProductsScreenState extends State<CustomerProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            const Text(
              "¡Bienvenid@!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SearchBar(
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 10),
              ),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Abrir opciones de búsqueda
                },
              ),
              hintText: 'Buscar un producto...',
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Categorías",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return buildCategoryCard(
                        category: Category(
                          id: index.toString(),
                          name: "Categoría $index",
                          creationDate: DateTime.now(),
                          hidden: false,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return buildProductCard(
                    product: Product(
                      id: index.toString(),
                      name: "Producto $index",
                      description: "Descripción del producto $index",
                      categoryId: "1",
                      creationDate: DateTime.now(),
                      hidden: false,
                      stock: 10,
                      discount: 0.0,
                      price: 100.0,
                      imageUrl: "https://via.placeholder.com/150",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildProductCard({required Product product}) {
    return Card(
      child: Column(
        children: [
          Image.network(
            product.imageUrl,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
          Text(product.name),
          Text("\$${product.price}"),
        ],
      ),
    );
  }

  buildCategoryCard({required Category category}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {},
        child: Chip(
          label: Text(category.name),
        ),
      ),
    );
  }
}
