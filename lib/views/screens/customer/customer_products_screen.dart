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

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    categoriesProvider = context.watch<CategoriesProvider>();
    productsProvider = context.watch<ProductsProvider>();

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
                  height: 8,
                ),
                SizedBox(
                  height: 50,
                  child: buildCategoriesList(),
                ),
                const SizedBox(height: 16, child: Divider()),
              ],
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
          // Muestra un indicador de carga mientras se obtienen los datos
          return const Center(
            child: CircularProgressIndicator(),
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
          // Muestra un indicador de carga mientras se obtienen los datos
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
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
