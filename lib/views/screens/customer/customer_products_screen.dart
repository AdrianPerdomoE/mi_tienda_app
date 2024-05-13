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
  int productsCount = 0;
  String searchFilter = '';
  List<String> categoriesFilter = [];

  @override
  void initState() {
    super.initState();
    final productsProvider = context.read<ProductsProvider>();
    productsProvider.getProducts();
  }

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

    setState(() {
      searchFilter = productsProvider.searchFilter;
      categoriesFilter = productsProvider.categoriesFilter;
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
              controller: TextEditingController(text: searchFilter),
              onChanged: (value) => searchFilter = value,
              onSubmitted: (value) =>
                  productsProvider.setSearchFilter(searchFilter),
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
                      productsProvider.setSearchFilter(searchFilter),
                ),
              ],
              hintText: 'Buscar productos...',
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Categorías",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    if (categoriesFilter.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            productsProvider.resetCategoriesFilter();
                          });
                        },
                        child: const Text("Limpiar filtros"),
                      ),
                  ],
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
            if (searchFilter.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$productsCount producto${productsCount != 1 ? 's' : ''} encontrados",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          searchFilter = '';
                          productsProvider.setSearchFilter(searchFilter);
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
