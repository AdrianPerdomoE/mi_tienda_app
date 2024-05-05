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
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: () {},
        child: Card(
          color: appDataProvider.backgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: appDataProvider.primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
            child: Text(
              widget.category.name,
              style: TextStyle(
                color: appDataProvider.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
