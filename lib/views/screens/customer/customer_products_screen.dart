import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/utils/amount_details.dart';
import 'package:mi_tienda_app/controllers/utils/custom_formats.dart';
import 'package:mi_tienda_app/models/category.dart';
import 'package:mi_tienda_app/models/product.dart';
import 'package:provider/provider.dart';
import 'package:mi_tienda_app/controllers/providers/products_provider.dart';

class CustomerProductsScreen extends StatefulWidget {
  const CustomerProductsScreen({super.key});

  @override
  State<CustomerProductsScreen> createState() => _CustomerProductsScreenState();
}

class _CustomerProductsScreenState extends State<CustomerProductsScreen> {
  @override
  Widget build(BuildContext context) {
    ProductsProvider productsProvider = context.watch<ProductsProvider>();

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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return buildCategoryCard(
                        context,
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
                const SizedBox(height: 16, child: Divider()),
              ],
            ),
            Expanded(
              child: buildProductsList(productsProvider.products),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryCard(BuildContext context, {required Category category}) {
    AppDataProvider appDataProvider = context.watch<AppDataProvider>();

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {},
        child: Chip(
          label: Text(
            category.name,
            style: TextStyle(
                color: appDataProvider.primaryColor,
                fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: appDataProvider
                  .primaryColor, // Cambiar el color del borde a amarillo
              width: 1, // Grosor del borde
            ),
            borderRadius: BorderRadius.circular(8.0), // Radio de las esquinas
          ),
        ),
      ),
    );
  }

  Widget buildProductsList(Stream<List<Product>> productStream) {
    return StreamBuilder<List<Product>>(
      stream: productStream,
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
            return buildProductCard(context, product: product);
          },
        );
      },
    );
  }

  Widget buildProductCard(BuildContext context, {required Product product}) {
    AppDataProvider appDataProvider = context.watch<AppDataProvider>();

    Map<String, double> dcValues =
        discountValues(product.price, product.discount);
    double price = dcValues['price']!;
    double discount = dcValues['discount']!;
    double discountAmount = dcValues['discountAmount']!;
    double finalPrice = dcValues['finalPrice']!;

    return InkWell(
      onTap: () => showProductDetails(product, context),
      child: Card(
        color: appDataProvider.backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: appDataProvider.accentColor, // Color del borde
            width: 1, // Grosor del borde
          ),
          borderRadius: BorderRadius.circular(8.0), // Radio de las esquinas
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: appDataProvider.backgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: appDataProvider.accentColor,
                    width: 1,
                  ),
                ),
              ),
              child: ClipRRect(
                child: Image.network(
                  product.imageUrl,
                  height: 70,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 8, top: 10),
              child: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  color: appDataProvider.textColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 12),
              child: Row(
                children: [
                  Text(
                    toCOP(price),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: appDataProvider.accentColor,
                      decoration: discount != 0
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (discount != 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        toCOP(finalPrice),
                        style: TextStyle(
                          fontSize: 14,
                          color: appDataProvider.accentColor,
                        ),
                      ),
                    ),
                  if (discount != 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: appDataProvider.accentColor,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          toPercentage(discount),
                          style: TextStyle(
                            fontSize: 10,
                            color: appDataProvider.backgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appDataProvider.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                    ),
                    onPressed: () {
                      // Agregar al carrito
                    },
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: appDataProvider.backgroundColor,
                      size: 14,
                      weight: 500,
                    ),
                    label: Text(
                      'Añadir',
                      style: TextStyle(
                          color: appDataProvider.backgroundColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showProductDetails(Product product, BuildContext context) {
    AppDataProvider appDataProvider = context.read<AppDataProvider>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appDataProvider.backgroundColor,
          alignment: Alignment.center,
          contentPadding: const EdgeInsets.all(24),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          title: Text(product.name),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          titleTextStyle: TextStyle(
            color: appDataProvider.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          contentTextStyle: const TextStyle(
            fontSize: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: appDataProvider.backgroundColor,
                  ),
                  child: ClipRRect(
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: appDataProvider.accentColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "\$ ${product.price.toStringAsFixed(0).replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},',
                      )}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: appDataProvider.textColor),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: appDataProvider.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
              ),
              onPressed: () {
                // Agregar al carrito
              },
              icon: Icon(
                Icons.add_shopping_cart,
                color: appDataProvider.backgroundColor,
                size: 16,
              ),
              label: Text(
                'Añadir',
                style: TextStyle(
                  color: appDataProvider.backgroundColor,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
