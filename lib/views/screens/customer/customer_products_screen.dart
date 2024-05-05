import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/providers/categories_provider.dart';
import 'package:mi_tienda_app/models/category.dart';
import 'package:mi_tienda_app/models/product.dart';
import 'package:mi_tienda_app/views/widgets/category_card.dart';
import 'package:mi_tienda_app/views/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:mi_tienda_app/controllers/providers/products_provider.dart';

class CustomerProductsScreen extends StatefulWidget {
  const CustomerProductsScreen({super.key});

  @override
  State<CustomerProductsScreen> createState() => _CustomerProductsScreenState();
}

class _CustomerProductsScreenState extends State<CustomerProductsScreen> {
  late AppDataProvider appDataProvider;
  late CategoriesProvider categoriesProvider;
  late ProductsProvider productsProvider;

  String searchValue = '';
  int productsCount = 0;

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    categoriesProvider = context.watch<CategoriesProvider>();
    productsProvider = context.watch<ProductsProvider>();

    productsProvider.products.listen((products) {
      setState(() {
        productsCount = products.length;
      });
    });

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
              controller: TextEditingController(text: searchValue),
              onChanged: (value) => searchValue = value,
              onSubmitted: (value) =>
                  productsProvider.filterProductsByName(value),
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 10),
              ),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Abrir opciones de búsqueda
                },
              ),
              trailing: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () =>
                      productsProvider.filterProductsByName(searchValue),
                ),
              ],
              hintText: 'Buscar productos...',
            ),
            const SizedBox(
              height: 16,
            ),
            if (searchValue.isEmpty)
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
                    height: 8,
                  ),
                  SizedBox(
                    height: 50,
                    child: buildCategoriesList(),
                  ),
                  const SizedBox(height: 16, child: Divider()),
                ],
              ),
            if (searchValue.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$productsCount producto${productsCount != 1 ? 's' : ''} encontrados",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          searchValue = '';
                          productsProvider.filterProductsByName(searchValue);
                        });
                      },
                      child: const Text("Limpiar búsqueda"),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: buildProductsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoriesList() {
    return StreamBuilder<List<Category>>(
      stream: categoriesProvider.categories,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No hay categorías disponibles"),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final Category category = snapshot.data![index];
            return CategoryCardWidget(category: category);
          },
        );
      },
    );
  }

  Widget buildProductsList() {
    return StreamBuilder<List<Product>>(
      stream: productsProvider.products,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No hay productos disponibles"),
          );
        }

        return GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final Product product = snapshot.data![index];
            return ProductCardWidget(product: product);
          },
        );
      },
    );
  }
}
