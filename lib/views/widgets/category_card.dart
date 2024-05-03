import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/models/category.dart';
import 'package:provider/provider.dart';

class CategoryCardWidget extends StatefulWidget {
  final Category category;
  const CategoryCardWidget({super.key, required this.category});

  @override
  State<CategoryCardWidget> createState() => _CategoryCardWidgetState();
}

class _CategoryCardWidgetState extends State<CategoryCardWidget> {
  late AppDataProvider appDataProvider;

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {},
        child: Chip(
          label: Text(
            widget.category.name,
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
}
