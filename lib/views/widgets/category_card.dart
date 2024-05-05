import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/providers/products_provider.dart';
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
  late ProductsProvider productsProvider;

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    productsProvider = context.watch<ProductsProvider>();

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
            if (isSelected) {
              productsProvider.addCategoryToFilter(widget.category.id);
            } else {
              productsProvider.removeCategoryToFilter(widget.category.id);
            }
          });
        },
        child: Stack(
          children: [
            Card(
              color: isSelected
                  ? appDataProvider.primaryColor
                  : appDataProvider.backgroundColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: appDataProvider.primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      widget.category.name,
                      style: TextStyle(
                        color: isSelected
                            ? appDataProvider.backgroundColor
                            : appDataProvider.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.close,
                          color: isSelected
                              ? appDataProvider.backgroundColor
                              : appDataProvider.primaryColor,
                          size: 14,
                        ),
                      )
                  ],
                ),
              ),
            ),
            // if (isSelected)
            //   const Positioned(
            //     top: 0,
            //     right: 0,
            //     child: Icon(
            //       Icons.close,
            //       color: Colors.red,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
