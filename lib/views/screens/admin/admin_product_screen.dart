import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/providers/products_provider.dart';
import 'package:mi_tienda_app/controllers/services/categories_database_service.dart';
import 'package:mi_tienda_app/models/category.dart';
import 'package:mi_tienda_app/views/widgets/category_card.dart';
import 'package:mi_tienda_app/views/widgets/create_product_dialog.dart.dart';
import 'package:mi_tienda_app/views/widgets/section_single_child_add_button.dart';
//Widgets
import 'package:mi_tienda_app/views/widgets/create_category_dialog.dart.dart';
import 'package:mi_tienda_app/views/widgets/products_admin_grid.dart';
import 'package:mi_tienda_app/views/widgets/section_add_button.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  int productsCount = 0;
  String searchFilter = '';
  List<String> categoriesFilter = [];
  String categoryName = '';
  late double _width;
  late double _height;
  final CategoriesDatabaseService _categoriesDatabaseService =
      GetIt.instance.get<CategoriesDatabaseService>();

  late ScrollController _controller;
  late AppDataProvider appDataProvider;
  late ProductsProvider productsProvider;

  @override
  void initState() {
    super.initState();
    final productsProvider = context.read<ProductsProvider>();
    productsProvider.getProducts();
    productsProvider.setOnlyVisible(false);
  }

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    productsProvider = context.watch<ProductsProvider>();
    _controller = PrimaryScrollController.of(context);
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    productsProvider.products.listen((products) {
      setState(() {
        productsCount = products.length;
      });
    });

    setState(() {
      searchFilter = productsProvider.searchFilter;
      categoriesFilter = productsProvider.categoriesFilter;
    });

    return _buildUi();
  }

  _buildUi() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: SingleChildScrollView(
          controller: _controller,
          child: Column(children: [
            _buildSearch(),
            _buildCategorySection(),
            _buildProductSection(),
          ])),
    );
  }

  Widget _buildSearch() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: SearchBar(
        controller: TextEditingController(text: searchFilter),
        onChanged: (value) => searchFilter = value,
        onSubmitted: (value) => productsProvider.setSearchFilter(searchFilter),
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
          if (searchFilter.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchFilter = '';
                productsProvider.setSearchFilter(searchFilter);
              },
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => productsProvider.setSearchFilter(searchFilter),
          ),
        ],
        hintText: 'Buscar productos...',
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      width: _width,
      height: _height * 0.16,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SectionChildlessAddButton(
              title: 'Categorías',
              onAdd: () {
                _buildShowCategoryPopup(context);
              },
            ),
            StreamBuilder(
                stream: _categoriesDatabaseService.categories
                    as Stream<List<Category>>,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.active:
                      return _buildCategoryList(snapshot);
                    default:
                      return const Text('Error');
                  }
                }),
          ]),
    );
  }

  Widget _buildCategoryList(AsyncSnapshot<List<Category>> snapshot) {
    if (!snapshot.hasData) {
      return const Text('No hay datos');
    }
    if (snapshot.data!.isEmpty) {
      return const Text('No hay categorías registradas');
    }
    return Expanded(
      child: Container(
        width: _width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return CategoryCardWidget(category: snapshot.data![index]);
          },
        ),
      ),
    );
  }

  Widget _categoryButton({required String label}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {},
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
                color: appDataProvider.primaryColor,
                fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: appDataProvider.primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildProductSection() {
    return SectionAddButton(
        title: "Productos",
        onAdd: () {
          showDialog(
            context: context,
            builder: (context) => const CreateProductDialog(),
          );
        },
        children: [
          StreamBuilder(
              stream: productsProvider.products,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  case ConnectionState.active:
                    return _productGrid(snapshot);
                  default:
                    return const Text('Error');
                }
              })
        ]);
  }

  Widget _productGrid(AsyncSnapshot<List<Product>> snapshot) {
    if (!snapshot.hasData) {
      return const Text('No hay datos');
    }
    if (snapshot.data!.isEmpty) {
      return const Text('No hay productos registrados');
    }

    return ProductGrid(
      products: snapshot.data!,
      controller: _controller,
    );
  }

  _buildShowCategoryPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateCategoryDialog();
        });
  }
}
